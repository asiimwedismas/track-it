require 'rails_helper'
RSpec.describe AuthenticateUser do
  let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password') }

  subject(:valid_auth_obj) { described_class.new(test_user.email, test_user.password) }
  subject(:invalid_auth_obj) { described_class.new(test_user.email, 'passs') }

  describe '#call' do
    context 'Given valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    context 'Given invalid credentials' do
      it 'raises an authentication error' do
        expect { invalid_auth_obj.call }
          .to raise_error(ExceptionHandler::AuthenticationError, /Invalid credentials/)
      end
    end
  end
end
