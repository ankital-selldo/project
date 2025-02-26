class ClubsController < ApplicationController
  
  def welcome
  end

  def my_club
    render :my_club
  end

  def new
  end

  def index
    @clubs = Club.all
  end

  def show
  end
  
  def edit
  end

end