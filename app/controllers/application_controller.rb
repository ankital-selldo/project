class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_student  # Add this line

  skip_before_action :verify_authenticity_token
  before_action :authorized, except: [:welcome]

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
end