class AuthController < ApplicationController
  skip_before_action :authorized, only: [:signup, :login]

  def signup
    # Rails.logger.debug(params.inspect)
    binding.pry
    @student = Student.new(student_params)
    
    binding.pry
    if @student.save
      token = encode_token({ student_id: @student.id })
      render json: {
        student: @student,
        token: token
      }, status: :created
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @student = Student.find_by(email: params[:email])

    if @student && @student.authenticate(params[:password])
      token = encode_token({ student_id: @student.id })
      render json: {
        student: @student,
        token: token
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def student_params
    params.permit(:name, :email, :password, :role)
  end
end