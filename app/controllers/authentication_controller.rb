class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token)
  rescue ExceptionHandler::AuthenticationError => e
    json_response({ auth_token: nil, message: e }, :unauthorized)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
