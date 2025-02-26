class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def welcome
  end

  def not_found
  end

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
      format.json { render json: @event.as_json(include: :club) }
    end
  end

  def new
    @event = Event.new
    authorize @event
    @club = current_student.clubs.first # Fetch the first club associated with the current student
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    @club = current_student.clubs.first # Fetch the club again in create action

    respond_to do |format|
      if @event.save
        binding.pry # Remove or keep for debugging
        format.html { redirect_to event_path(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created }
      else
        binding.pry # Remove or keep for debugging
        format.html { flash.now[:alert] = 'Failed to create event.'; render :new }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @event
    @club = @event.club # Get the club directly from the event
    binding.pry
  end

  def update
    authorize @event
    respond_to do |format|
      if @event.update(event_params)
    binding.pry

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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'Event was successfully deleted.' }
      format.json { head :no_content }
    end
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