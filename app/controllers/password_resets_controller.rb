class PasswordResetsController < ApplicationController

  skip_before_action :authorized

  def welcome
  end

  def new
  end

  def create
    @student = Student.find_by(email: params[:email])
   
    if @student.present?
      PasswordMailer.with(student: @student).reset.deliver_now
    end

    redirect_to root_path, notice: "If you have an account, we have sent mail to you.", status: :ok
  end


  def edit
    @student = Student.find_signed!(params[:token], purpose: "password_reset")
  rescue ActiveSupport::MessageViewer::InvalidSignature
    
    redirect_to root_path, alert: "Your session has expired. Please try again."
  end
  
  
  def update
    
    @student = Student.find_signed!(params[:token], purpose: "password_reset")
    if @student.update(password_params)
      
      redirect_to students_path, notice: "Your password has been successfully reset"
    else

      render :edit
    end
  end


  private 


  def password_params

    params.require(:student).permit(:password, :password_confirmation)
  end
end