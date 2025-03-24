class AuthService
  attr_reader :errors

  def initialize
    @errors = []
  end

  def signup(student_params)
    student = Student.new(student_params)
    
    if student.save
      create_auth_token(student)
      { success: true, student: student, token: encode_token(student.id) }
    else
      @errors = student.errors.full_messages
      { success: false, errors: @errors }
    end
  end

  def login(email, password)
    student = Student.find_by(email: email)
    
    if student && student.authenticate(password)
      create_auth_token(student)
      { success: true, student: student, token: encode_token(student.id) }
    else
      @errors << "Invalid email or password"
      { success: false, errors: @errors }
    end
  end

  def logout
    { success: true }
  end

  def is_logged_in?(student_id)
    student_id.present? && Student.exists?(student_id)
  end

  def create_auth_token(student)
    # This would create and return the cookie options in the controller
    { 
      value: student.id,
      expires: 7.days.from_now,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end
  
  private


  def encode_token(student_id)
    # Assuming you have a JWT encoding method somewhere, or you could add it here
    # This would be the JWT token for API access
    payload = { student_id: student_id }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end