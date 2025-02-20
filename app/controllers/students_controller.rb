  class StudentsController < ApplicationController
    before_action :authorized, except: [:welcome]
    helper_method :logged_in?, :current_student  # Add this line

    # GET /users
    def index
      @students = Student.all
    end

    def new 
      @student = Student.new
    end
  
    # GET /users/{username}
    def show
    end
  
    # POST /users
    def create
      @student = Student.new(student_params)
      if @student.save
        # render json: @student, status: :created
        redirect_to students_path
      else
        render "new_signup"
      end
    end
  
    # PUT /users/{username}
    def update
      # unless @student.update(student_params)
      #   render json: { errors: @student.errors.full_messages },
      #          status: :unprocessable_entity
      # end
    end
  
    # DELETE /users/{username}
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