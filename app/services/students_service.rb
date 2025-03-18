class StudentsService

  def initialize(student, role, code, password, password_confirmation)
    @student = student
    @role = role
    @code = code
    @password = password
    @password_confirmation = password_confirmation

  end

  def call 
    if valid_role_upgrade?
      upgrade_role
      true
    else
      false
    end
  end

  def valid_role_upgrade?

    case @role
    when "admin"
      AccessCode.verify_admin_code(@code)
    when "club_head"
      AccessCode.verify_club_head_code(@code)
    else
      false
    end
  end


  def upgrade_role
    @student.update(role: @role, password:  @password, password_confirmation: @password_confirmation)
  end
end