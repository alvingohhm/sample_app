class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

def redirect_to(options = {}, response_status = {})
  ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
  super(options, response_status)
end
  
end
