class RegistersController < ApplicationController
  before_action :set_event, only: [:new, :create]

  def welcome
  end

  def new
    @register = Register.new
    @register.event = @event if @event


    if @register.event_id == nil
      respond_to do |format|
        format.html {  
          redirect_to root_path, alert: 'NO event found for registeration'
        }
      end
    end
  end

  def show
    @register = Register.find(params[:id]) || Register.find(params[:event_id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { flash[:alert] = 'Page not found.'; redirect_to root_path }
        format.json { render json: { error: 'Page not found' }, status: :unauthorized }
      end
  end

  def index
    @registers = current_student.registers.includes(:event)
  end

  def create
    @register = current_student.registers.build(register_params)
    

    if current_student.registers.exists?(event_id: @register.event_id)
      redirect_to registers_path, notice: 'You have already registered for this event.'
      return
    end

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
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { 
          flash[:alert] = 'Page not found'
          redirect_to root_path, status: :not_found
          }
        format.json { render json: { error: 'Page not found' }, status: :unauthorized }
      end
  end

  def register_params
    params.require(:register).permit(:event_id, :name, :branch, :year)
  end

 
end