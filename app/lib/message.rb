class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_user_registration
    message = "Validation failed: Name can't be blank (minimum is 5 characters),"
    message << " Email can't be blank & must be valid, Password can't be blank"
  end

  def self.email_taken
    'Email has already been taken'
  end

  def self.admin_only
    'Not authorised to access this resource'
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end
end
