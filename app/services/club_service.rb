class ClubService
  attr_reader :current_student, :errors

  def initialize(current_student)
    @current_student = current_student
    @errors = []
  end

  def list_all_clubs
    Club.all
  end

  def find_club(id)
    Club.find(id)
  rescue ActiveRecord::RecordNotFound
    @errors << 'Club not found'
    nil
  end

  def new_club
    Club.new
  end

  def create_club(club_params)
    club = Club.new(club_params)
    club.student_id = current_student.id
    
    if club.save
      { success: true, club: club }
    else
      @errors = club.errors.full_messages
      { success: false, errors: @errors }
    end
  end

  def update_club(club, club_params)
    if club.update(club_params)
      { success: true, club: club }
    else
      @errors = club.errors.full_messages
      { success: false, errors: @errors }
    end
  end

  def destroy_club(club)
    if club.destroy
      { success: true }
    else
      @errors = club.errors.full_messages
      { success: false, errors: @errors }
    end
  end
end