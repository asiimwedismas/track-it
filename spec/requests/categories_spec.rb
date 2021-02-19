require 'rails_helper'

RSpec.describe 'Categories API', type: :request do
  let!(:category1) { Category.create(title: 'abc') }
  let!(:category2) { Category.create(title: 'abd') }
  let!(:category3) { Category.create(title: 'abe') }
  let(:test_categoryid) { category1.id }

  let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password') }
  let(:headers) { valid_headers }

  describe 'GET /categories' do
    before { get '/categories', params: {}, headers: headers }
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns categories' do
      expect(json).not_to be_empty
      expect(json.size).to eq(3)
    end
  end

  describe 'GET /categories/:id' do
    before { get "/categories/#{test_categoryid}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(test_categoryid)
      end
    end

    context 'when the record does not exist' do
      let(:test_categoryid) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(Message.not_found)
      end
    end
  end
end
