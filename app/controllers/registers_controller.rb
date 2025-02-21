class RegistersController < ApplicationController

  def new
    @register = Register.new
  end

  def welcome
  end

  def index
  end

  def show
    @register = Register.find(params[:id])
  end

  def edit
  end

  def create
    @register = Register.new(register_params)
    if @register.save
      # redirect_to registers_path
      render json: {register: @register, status: :created}
    else
      # redirect_to new_register_path
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.permit(:name, :branch, :year)
  end
end