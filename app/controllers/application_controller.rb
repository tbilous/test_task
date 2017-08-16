require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
end
