  class StudentsController < ApplicationController
    before_action :authorized, except: [:welcome]
    # helper_method :logged_in?, :current_student  

    def index
      @students = Student.all
    end

    def new 
      @student = Student.new
    end
  
    def show
    end
  
    def create
      @student = Student.new(student_params)
      if @student.save
        redirect_to students_path
      else
        render "new_signup"
      end
    end


      def role_upgrade
        render :role_upgrade
      end
    
      def verify_role_code
        role_type = params[:role_type]
        code = params[:code]
        pw = params[:password]
        confirm_pw = params[:confirm_password]
        
        if role_type == "admin" && AccessCode.verify_admin_code(code)
          current_student.update(role: "admin", password: pw, password_confirmation: confirm_pw)
  
          flash[:notice] = "You have been upgraded to Admin!"
          redirect_to root_path
        elsif role_type == "club_head" && AccessCode.verify_club_head_code(code)
          current_student.update(role: "club_head", password: pw, password_confirmation: confirm_pw)
          flash[:notice] = "You have been upgraded to Club Head!"
  
          redirect_to new_club_path
        else
          flash[:alert] = "Invalid code for #{role_type.humanize} role."
  
          redirect_to role_upgrade_path
        end
      end
  
    def update
      # unless @student.update(student_params)
      #   render json: { errors: @student.errors.full_messages },
      #          status: :unprocessable_entity
      # end
    end
  
    def destroy
      @student.destroy
    end
  
    private
    def student_params
      params.permit(
        :name, :email, :password, :role
      )
    end

  end