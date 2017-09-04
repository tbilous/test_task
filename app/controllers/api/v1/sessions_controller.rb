class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :require_login!, only: [:create]

  respond_to :json

  def create
    return invalid_login_attempt unless params[:user_login].present?
    resource = User.find_for_database_authentication(email: params[:user_login][:email])
    resource ||= User.new

    if resource.valid_password?(params[:user_login][:password])
      auth_token = resource.generate_auth_token
      render json: { auth_token: auth_token }
    else
      invalid_login_attempt
    end
  end

  def destroy
    resource = current_person
    resource.invalidate_auth_token
    head :ok
  end

  private

  def invalid_login_attempt
    render json: { errors: [{ detail: 'Error with your login or password' }] }, status: 401
  end
end
