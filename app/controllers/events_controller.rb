# class EventsController < ApplicationController
#   before_action :set_event, only: [:show, :edit, :update, :destroy, :registrations]

#   after_action :verify_authorized, except: :index
#   after_action :verify_policy_scoped, only: :index

#   def welcome
#   end

#   def index
#     @events = policy_scope(Event).includes(:club).order(event_date: :asc, event_time: :asc)
#     respond_to do |format|
#       format.html
#       format.json { render json: @events.as_json(include: :club) }
#     end
#   end

#   def show
#     authorize @event
#     respond_to do |format|
#       format.html
#       # format.json { render json: @event.as_json(include: :club) }
#       format.any { head :not_found }
#     end
#   end

#   def new
#     @event = Event.new
#     @event.club_id = params[:club_id] if params[:club_id].present?
#     authorize @event
#     @club = current_student.clubs.first 
#   end

#   def create
#     @event = Event.new(event_params)
#     authorize @event
#     @club = current_student.clubs.first 

#     if @event.club_id.blank? && current_student.role == "club_head" && current_student.clubs.any?
#       @event.club_id = current_student.clubs.first.id
#     end

#     respond_to do |format|
#       if @event.save
#         format.html { redirect_to event_path(@event), alert: 'Event was successfully created.' }
#         format.json { render json: @event, status: :created }
#       else
#         format.html { flash.now[:alert] = 'Failed to create event.'
#         redirect_to root_path, status: :unauthorized
#        }
#         format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
#       end
#     end
#   end

#   def edit
#     authorize @event
#     @club = @event.club 
#   end

#   def update
#     authorize @event
#     respond_to do |format|
#       if @event.update(event_params)

#         format.html { redirect_to event_path(@event), notice: 'Event was successfully updated.' }
#         format.json { render json: @event, status: :ok }
#       else
#         format.html { flash.now[:alert] = 'Failed to update event.'; render :edit, status: :unprocessable_entity }
#         format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
#       end
#     end
#   end

#   def destroy
#     authorize @event
#     @event.destroy
#     respond_to do |format|
#       format.html { redirect_to events_path, alert: 'Event was successfully deleted.' }
#       format.json { render json: { errors: @event.errors.full_messages }, status: :unauthorized }

#     end
#   end

#   def registrations
#     if @event.nil?
#       flash[:alert] = "Event not found."
#       redirect_to my_club_path and return
#     end

    
#     authorize @event
#     @registrations = @event.registers.includes(:student)
#   end

#   private

#   def set_event
#     @event = Event.includes(:club).find(params[:id])
#   rescue ActiveRecord::RecordNotFound
#     respond_to do |format|
#       format.html { 
#         flash[:alert] = 'Event not found'
#         redirect_to events_path, status: :not_found
#         }
#       format.json { render json: { error: 'Event not found' }, status: :unauthorized }
#     end
#   end

#   def event_params
#     params.require(:event).permit(
#       :event_name,
#       :event_desc,
#       :event_image,
#       :event_register_link,
#       :event_venue,
#       :event_time,
#       :event_date,
#       :event_deadline,
#       :club_id
#     )
#   end
# end

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :registrations]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  
  def welcome
  end
  
  def index
    service = EventService.new(current_student) 
    @events = service.list_events(policy_scope(Event))
    
    respond_to do |format|
      format.html
      format.json { render json: @events.as_json(include: :club) }
    end
  end
  
  def show
    authorize @event

    respond_to do |format|
      format.html
      format.any { head :not_found }
    end
  end
  
  def new
    service = EventService.new(current_student)
    @event = service.new_event(params)
    authorize @event
    @club = service.get_student_first_club
  end
  
  def create
    service = EventService.new(current_student)
    @event = Event.new(event_params)
    
    authorize @event 
    result = service.create_event(event_params)
    @event = result[:event] || Event.new(event_params) 
    @club = service.get_student_first_club
    @errors = result[:errors]

    respond_to do |format|
      if result[:success]
        format.html { redirect_to event_path(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created }
      else
        format.html { flash.now[:alert] = 'Failed to create event. ' + result[:errors].first; render :new }
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    service = EventService.new(current_student)
    authorize @event
    @club = service.get_club_for_event(@event)
  end
  
  def update
    service = EventService.new(current_student)
    authorize @event
    result = service.update_event(@event, event_params)
    
    respond_to do |format|
      if result[:success]
        format.html { redirect_to event_path(@event), notice: 'Event was successfully updated.' }
        format.json { render json: @event }
      else
        flash.now[:alert] = 'Failed to update event.'
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    service = EventService.new(current_student)
    authorize @event
    result = service.destroy_event(@event)
    
    respond_to do |format|
      if result[:success]
        format.html { redirect_to events_path, notice: 'Event was successfully deleted.' }
        format.json { head :no_content }
      else
        flash[:alert] = 'Failed to delete event.'
        format.html { redirect_to events_path }
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end
  
  def registrations
    service = EventService.new(current_student)
    authorize @event
    result = service.event_registrations(@event)
    if result[:success]
      @registrations = result[:registrations]
    else

      flash[:alert] = result[:errors].join(", ")
      redirect_to my_club_path
    end
  end
  
  private
  
  def set_event
    service = EventService.new(current_student)
    @event = service.find_event(params[:id])
    
    if @event.nil?
      respond_to do |format|
      format.html { flash[:notice] = 'Event not found.'; redirect_to events_path }
      format.json { render json: { error: 'Event not found' }, status: :not_found }
      end
    end
  end
  
  def event_params
    params.require(:event).permit(
      :event_name,
      :event_desc,
      :event_image,
      :event_register_link,
      :event_venue,
      :event_time,
      :event_date,
      :event_deadline,
      :club_id
    )
    end
  end