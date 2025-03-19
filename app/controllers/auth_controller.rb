class AuthController < ApplicationController
  skip_before_action :authorized, only: [:signup, :login, :new_signup, :new_login]
  before_action :redirect_to_if_logged_in, only: [:login, :signup, :new_login, :new_signup]

  def new_signup
    @student = Student.new
  end

  def new_login
  end

  def welcome
  end

  def logout
  end

  def signup

    @student = Student.new(student_params)
    token = encode_token({ student_id: @student.id })
    
    if @student.save

      cookies.signed[:student_id] = {
        value: @student.id,
        expires: 7.days.from_now,
        httponly: true,
        secure: Rails.env.production?
      }

      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Successfully signed up!' }
        
        format.json { render json: { student: @student }, status: :created }
      end
    else
      
      respond_to do |format|
        format.html { render :new_signup, status: :unprocessable_entity }
        format.json { render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  def login
    @student = Student.find_by(email: params[:email])
    if @student && @student.authenticate(params[:password])
      
      cookies.signed[:student_id] = {
        value: @student.id,
        expires: 7.days.from_now,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }
      
      token = encode_token({ student_id: @student.id })
      
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Successfully logged in!' }
        format.json { 
          render json: {
            student: @student,
            token: token
          }, status: :ok 
        }
      end
    else
      respond_to do |format|
        format.html { 
          flash.now[:alert] = 'Invalid email or password'
          render :new_login, status: :unauthorized
        }
        format.json { render json: { error: 'Invalid email or password' }, status: :unauthorized }
      end
    end
  end

  def logout
    cookies.delete(:student_id)
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Successfully logged out!' }
      format.json { head :no_content }
    end
  end
  

  private

  def student_params
    params.require(:student).permit(:name, :email, :password, :role)
  end

  def redirect_to_if_logged_in

    if logged_in?
      respond_to do |format|
        format.html {
          flash[:notice] = "You are already logged in"
          redirect_to students_path
        }
        format.json {
          render json: {message: "Already logged in"}, status: :forbidden
        }
      end
    end
  end

end