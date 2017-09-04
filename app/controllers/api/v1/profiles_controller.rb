class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :load_user,only: [:me, :show]
  skip_before_action :require_login!, only: [:create]
  before_action :check_user, only: [:create]

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

  def me
    respond_with @user
  end

  def show
    respond_with @user
  end

  private

  def load_user
    @user = current_person
  end

  def check_user
    invalid_login_attempt unless params[:user_registration]
                                   .present? || User.find_by_email(params[:user_registration]).nil?
  end

  def user_params
    params.require(:user_registration).permit(:email, :password)
  end

  def invalid_login_attempt
    render json: { errors: [{ detail: 'Wrong registration params' }] }, status: 422
  end
end
