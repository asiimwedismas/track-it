require 'rails_helper'
RSpec.describe AuthorizeApiRequest do
  let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password') }

  let(:header) { { 'Authorization' => token_generator(test_user.id) } }
  subject(:valid_request_obj) { described_class.new(header) }
  subject(:invalid_request_obj) { described_class.new({}) }

  describe '#call' do
    context 'Given valid request' do
      it 'returns user object' do
        result = valid_request_obj.call
        expect(result[:user]).to eq(test_user)
      end
    end

    context 'Given invalid request' do
      context 'Given missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'Given invalid token' do
        subject(:invalid_request_obj) { described_class.new('Authorization' => token_generator(5)) }

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'Given token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(test_user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { valid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
        end
      end

      context 'Given a fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end
