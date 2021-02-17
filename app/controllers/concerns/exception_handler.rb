module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end

  class AuthorisationError < StandardError; end

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  class EmailTaken < StandardError; end

  class UserRegistrationFailed < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound do |_error|
      json_response({ message: Message.not_found }, :not_found)
    end

    rescue_from ExceptionHandler::AuthorisationError, with: :forbidden_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ExceptionHandler::EmailTaken do |error|
      json_response({ message: error }, :bad_request)
    end

    rescue_from ExceptionHandler::UserRegistrationFailed do |error|
      json_response({ message: error }, :bad_request)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(error)
    json_response({ message: error.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(error)
    json_response({ message: error.message }, :unauthorized)
  end

  # JSON response with message; Status code 403 - Unauthorized
  def forbidden_request(error)
    json_response({ message: error.message }, :forbidden)
  end
end
