class ClubsController < ApplicationController
  before_action :authorized, except: [:welcome]

  before_action :set_club, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_user!
  # before_action :authorize_club_head, only: [:new, :create, :edit, :update, :destroy]

  def welcome
  end

  def my_club
    render :my_club
  end

  # GET /clubs
  def index
    @clubs = Club.all
  end

  # GET /clubs/1
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  def create
    @club = Club.new(club_params)
    @club.student_id = current_student.id
    binding.pry

    if @club.save
    binding.pry

      redirect_to @club, notice: 'Club was successfully created.'
    else
    binding.pry

      render :new
    end
  end

  # PATCH/PUT /clubs/1
  def update
    if @club.update(club_params)
      redirect_to @club, notice: 'Club was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clubs/1
  def destroy
    @club.destroy
    redirect_to clubs_url, notice: 'Club was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions
    def set_club
      puts "Params ID: #{params[:id]}" # Add this line
      @club = Club.find(params[:id])
      puts "Club: #{@club.inspect}" # Add this line
    rescue ActiveRecord::RecordNotFound
      puts "Club not found!" # Add this line
      @club = nil # Make sure to set @club to nil when not found.
    end

    # Only allow a list of trusted parameters through
    def club_params
      params.require(:club).permit(:club_name, :club_logo)
    end

    # Ensure only club_head role can create/edit/delete clubs
    def authorize_club_head
      unless current_user.role == 'club_head'
        redirect_to clubs_path, alert: 'Only club heads can perform this action.'
      end
    end
end