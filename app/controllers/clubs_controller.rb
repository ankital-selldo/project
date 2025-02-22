class ClubsController < ApplicationController
  
  def welcome
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