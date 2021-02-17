require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  # Authentication test suite
  describe 'POST /auth/login' do
    let!(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password') }

    let(:headers) { valid_headers.except('Authorization') }

    let(:valid_credentials) do
      {
        email: test_user.email,
        password: test_user.password
      }.to_json
    end

    let(:invalid_credentials) do
      {
        email: 'zx',
        password: 'zx'
      }.to_json
    end

    context 'When request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        body = JSON.parse(response.body)
        expect(body['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        body = JSON.parse(response.body)
        expect(body['message']).to match(/Invalid credentials/)
      end
    end
  end
end
