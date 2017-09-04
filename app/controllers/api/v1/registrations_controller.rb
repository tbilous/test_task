class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :require_login!, only: [:create]
  before_action :check_user

  respond_to :json

  def create
    resource = User.new(user_params)
    resource.save if resource.valid?
    if resource.persisted?
      @user = User.find_by_email(resource.email)
      auth_token = resource.generate_auth_token
      render json: { user: resource.id, auth_token: auth_token }
    else
      invalid_login_attempt
    end
  end

  private

  def check_user
    invalid_login_attempt unless params[:user_registration]
                                 .present? || User.find_by_email(params[:user_registration]).nil?
  end

  def user_params
    params.require(:user_registration).permit(:email, :password)
  end

  def invalid_login_attempt
    render json: { errors: [{ detail: 'Wrong registration params' }] }
  end
end
