class PasswordResetsController < ApplicationController

  skip_before_action :authorized

  def welcome
  end

  def new
  end

  def create
    @student = Student.find_by(email: params[:email])
    binding.pry

    if @student.present?
      binding.pry
      PasswordMailer.with(student: @student).reset.deliver_now
    end
    binding.pry

    redirect_to root_path, notice: "If you have an account, we have sent mail to you."
    
  end


  def edit
    @student = Student.find_signed!(params[:token], purpose: "password_reset")
    binding.pry
  rescue ActiveSupport::MessageViewer::InvalidSignature
    
    redirect_to root_path, alert: "Your session has expired. Please try again."
  end
  
  
  def update
    
    @student = Student.find_signed!(params[:token], purpose: "password_reset")
    binding.pry
    if @student.update(password_params)
    binding.pry
      
      redirect_to students_path, notice: "Your password has been successfully reset"
    else
    binding.pry

      render :edit
    end
  end


  private 


  def password_params

    params.require(:student).permit(:password, :password_confirmation)
  end
end