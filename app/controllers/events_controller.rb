class EventsController < ApplicationController

  def welcome
  end

  def new
  end

  def index
    @events = Event.all
    
  end

  

  def show
  end

  def edit
  end


  def create
    
  end
end