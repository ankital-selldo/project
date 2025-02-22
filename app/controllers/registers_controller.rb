class RegistersController < ApplicationController
  before_action :set_event, only: [:new, :create]

  def welcome
  end

  def new
    @register = Register.new
    @register.event = @event if @event
  end

  def index
    @registers = current_student.registers.includes(:event)
  end

  def create
    @register = current_student.registers.build(register_params)
    @register.student_id = current_student.id 
    
    if @register.save
      redirect_to root_path, notice: 'Successfully registered for the event!'
    else
      render :new, notice: 'Registration failed.'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id]) if params[:event_id]
  end

  def register_params
    params.require(:register).permit(:event_id, :name, :branch, :year)
  end

 
end