class EventService
  attr_reader :current_student, :errors
  
  def initialize(current_student)
    @current_student = current_student
    @errors = []
  end
  
  def list_events(policy_scope)
    policy_scope.includes(:club).order(event_date: :asc, event_time: :asc)
  end
  
  def find_event(id)
    Event.includes(:club).find(id)
    rescue ActiveRecord::RecordNotFound
    @errors << 'Event not found'
    nil
  end

  
  def new_event(params = {})
    event = Event.new
    event.club_id = params[:club_id] if params[:club_id].present?
    event
  end
  
  def create_event(event_params)
    event = Event.new(event_params)

    if event.club_id.blank? && current_student.role == "club_head" && current_student.clubs.any?
      event.club_id = current_student.clubs.first.id
    end
    if event.save
      { success: true, event: event }
    else
      @errors = event.errors.full_messages
      { success: false, errors: @errors }
    end

  end
  
  def update_event(event, event_params)
    if event.update(event_params)
      { success: true, event: event }
    else
      @errors = event.errors.full_messages
      { success: false, errors: @errors }
    end
  end
  
  def destroy_event(event)
    if event.destroy
      { success: true }
    else
      @errors = event.errors.full_messages
      { success: false, errors: @errors }
    end
  end
  
  def event_registrations(event)
    return { 
      success: false, errors: ['Event not found'] 
    } unless event
    registrations = event.registers.includes(:student)
    { success: true, registrations: registrations }
    
  end
  
  def get_club_for_event(event)
    event.club
  end
  
  def get_student_first_club
    current_student.clubs.first
  end

  end