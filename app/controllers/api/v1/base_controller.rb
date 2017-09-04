class Api::V1::BaseController < ActionController::Base
  before_action :require_login!
  helper_method :person_signed_in?, :current_person
  respond_to :json

  def user_signed_in?
    current_person.present?
  end

  def require_login!
    return true if authenticate_token
    render json: { errors: [{ detail: 'Access denied' }] }, status: 401
  end

  def current_person
    @_current_user ||= authenticate_token
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      User.where(auth_token: token).where('token_created_at >= ?', 1.month.ago).first
    end
  end
end
