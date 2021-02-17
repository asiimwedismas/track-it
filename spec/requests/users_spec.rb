# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:test_user) { User.new(name: 'dismas', email: 'email@email.com', password: 'password') }

  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    {
      name: test_user.name,
      email: test_user.email,
      password: test_user.password
    }
  end

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it "returns message => #{Message.account_created}" do
        body = JSON.parse(response.body)
        expect(body['message']).to match(Message.account_created)
      end

      it 'returns an authentication token' do
        body = JSON.parse(response.body)
        expect(body['auth_token']).not_to be_nil
      end
    end

    context 'when email has already been registered' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it "returns message => #{Message.email_taken}" do
        body = JSON.parse(response.body)
        expect(body['message']).to match(Message.email_taken)
      end

      it 'does not return an authentication token' do
        body = JSON.parse(response.body)
        expect(body['auth_token']).to be_nil
      end
    end

    context 'when name, email, or password or all are emitted' do
      before { post '/signup', params: {}, headers: headers }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it "returns message => #{Message.invalid_user_registration}" do
        body = JSON.parse(response.body)
        expect(body['message'])
          .to match(Message.invalid_user_registration)
      end

      it 'does not return an authentication token' do
        body = JSON.parse(response.body)
        expect(body['auth_token']).to be_nil
      end
    end
  end
end
