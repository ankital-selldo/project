class ClubsController < ApplicationController
  before_action :authorized, except: [:welcome]

  before_action :set_club, only: [:show, :edit, :update, :destroy]

  def welcome
  end

  def my_club
    authorize Club
    @clubs = policy_scope(Club)
    render :my_club
  end

  def index
    @clubs = Club.all
  end

  def show
    authorize @club
  end

  def new
    @club = Club.new
    authorize @club
  end

  def edit
    authorize @club

  end

  def create
    @club = Club.new(club_params)
    @club.student_id = current_student.id
    authorize @club
    binding.pry

    if @club.save
    binding.pry

      redirect_to @club, notice: 'Club was successfully created.'
    else
    binding.pry

      render :new
    end
  end

  def update
    authorize @club

    if @club.update(club_params)
      redirect_to @club, notice: 'Club was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @club

    @club.destroy
    redirect_to clubs_url, notice: 'Club was successfully deleted.'
  end

  private
    def set_club
      @club = Club.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @club = nil 
    end

    def club_params
      params.require(:club).permit(:club_name, :club_logo)
    end

    
end