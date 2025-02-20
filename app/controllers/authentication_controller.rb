# class AuthenticationController < ApplicationController
#   skip_before_action :authenticate_user!, only: [ :signup, :login ]

#   SECRET_KEY = Rails.application.secret_key_base

#   def signup
#     student = Student.new(student_params)

#     if student.save
#       token = generate_token(student.id)
#       render json: { student: student, token: token }, status: :created
#     else
#       render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   def login
#     student = Student.find_by(email: params[:email])

#     if student&.authenticate(params[:password])
#       token = generate_token(student.id)
#       render json: { student: student, token: token }, status: :ok
#     else
#       render json: { error: "Invalid email or password" }, status: :unauthorized
#     end
#   end


#   private

#   def student_params
#     params.require(:authentication).permit(:name, :email, :password, :role)
#   end

#   def generate_token(student_id)
#     JWT.encode({ student_id: student_id }, SECRET_KEY, "HS256")
#   end
# end