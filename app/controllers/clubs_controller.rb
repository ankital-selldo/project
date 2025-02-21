class ClubsController < ApplicationController

  def new
  end

  def welcome
  end

  def index
    @clubs = Club.all
  end

  def show
  end
  
  def edit
  end

end