class ErrorsController < ApplicationController
  def welcome
  end

  def not_found
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Page not found!" }  
      format.json { render json: { error: "Route not found" }, status: 404 }  
    end
  end
end
