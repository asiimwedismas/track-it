class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    email = User.find_by_email(params[:email])
    raise(ExceptionHandler::EmailTaken, Message.email_taken) if email

    user = User.create(user_params)
    raise(ExceptionHandler::UserRegistrationFailed, Message.invalid_user_registration) if user.id.nil?

    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password
    )
  end
end
