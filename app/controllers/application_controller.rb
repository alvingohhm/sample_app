class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

def redirect_to(options = {}, response_status = {})
  ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
  super(options, response_status)
end

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
  
end
