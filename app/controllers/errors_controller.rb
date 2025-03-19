class ErrorsController < ApplicationController
  def welcome
  end

  def not_found
    render json: { error: 'Route not found' }, status: 404
  end
end
