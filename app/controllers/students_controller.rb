  class StudentsController < ApplicationController

    before_action :authorize_request, except: :create
    # before_action :find_student, except: %i[create index]
  
    # GET /users
    def index
      @students = Student.all
      render json: @students, status: :ok
    end
  
    # GET /users/{username}
    def show
      render json: @student, status: :ok
    end
  
    # POST /users
    def create
      @student = Student.new(student_params)
      if @student.save
        render json: @student, status: :created
      else
        render json: { errors: @student.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  
    # PUT /users/{username}
    def update
      unless @student.update(student_params)
        render json: { errors: @student.errors.full_messages },
               status: :unprocessable_entity
      end
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