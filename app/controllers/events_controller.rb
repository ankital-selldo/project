class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :registrations]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def welcome
  end

  # def not_found
  # end

  def index
    @events = policy_scope(Event).includes(:club).order(event_date: :asc, event_time: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @events.as_json(include: :club) }
    end
  end

  def show
    authorize @event
    respond_to do |format|
      format.html
      # format.json { render json: @event.as_json(include: :club) }
      format.any { head :not_found }
    end
  end

  def new
    @event = Event.new
    @event.club_id = params[:club_id] if params[:club_id].present?
    authorize @event
    @club = current_student.clubs.first 
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    @club = current_student.clubs.first 

    if @event.club_id.blank? && current_student.role == "club_head" && current_student.clubs.any?
      @event.club_id = current_student.clubs.first.id
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created }
      else
        format.html { redirect_to root_path, flash.now[:alert] = 'Failed to create event.'; }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @event
    @club = @event.club 
  end

  def update
    authorize @event
    respond_to do |format|
      if @event.update(event_params)

        format.html { redirect_to event_path(@event), notice: 'Event was successfully updated.' }
        format.json { render json: @event }
      else
        binding.pry

        format.html { flash.now[:alert] = 'Failed to update event.'; render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @event
    binding.pry
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'Event was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def registrations
    if @event.nil?
      flash[:alert] = "Event not found."
      redirect_to my_club_path and return
    end

    
    authorize @event

    @registrations = @event.registers.includes(:student)
  end

  private

  def set_event
    @event = Event.includes(:club).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { flash[:notice] = 'Event not found.'; redirect_to events_path }
      format.json { render json: { error: 'Event not found' }, status: :unauthorized }
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