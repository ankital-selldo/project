class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_student, :is_role_club_head  # Add this line

  skip_before_action :verify_authenticity_token
  before_action :authorized, except: [:welcome]

  include Pundit::Authorization
  
  # Add Pundit's method for handling unauthorized access
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |format|
      format.html {
        flash[:alert] = "You are not authorized to perform this action."
        redirect_back(fallback_location: root_path)
      }
      format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
    end
  end

  # Tell Pundit to use current_student instead of current_user
  def pundit_user
    current_student
  end

  def not_found
    # render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    redirect_to root_path
  end
  
  private
  
  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def auth_header 
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_student
    @current_student ||= Student.find_by(id: cookies.signed[:student_id]) if cookies.signed[:student_id]
    # binding.pry
  end

  def logged_in?
    !!current_student
  end


  def authorized
    unless logged_in?
      respond_to do |format|
        format.html { 
          flash[:notice] = 'Please log in to access this page'
          redirect_to new_login_path 
        }
        format.json { render json: { message: 'Please log in' }, status: :unauthorized }
      end
    end
  end



  def is_role_club_head
    logged_in? && current_student.role == "club_head"
  end
  
  def is_role_admin
    logged_in? && current_student.role == "admin"
  end
  
  def is_role_user
    logged_in? && current_student.role == "user"
  end
end