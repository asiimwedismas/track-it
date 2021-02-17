require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password') }
  let(:test_user2) { User.create(name: 'asiimwe', email: 'asiimwe@email.com', password: 'password') }
  let(:headers) { valid_headers }

  let!(:category) { Category.create(title: 'Soft drinks') }
  let!(:item1) { Item.create(name: 'coca cola', category_id: category.id, user_id: test_user.id, amount: 1000) }
  let!(:item2) { Item.create(name: 'coca colaas', category_id: category.id, user_id: test_user.id, amount: 2000) }
  let!(:item3) { Item.create(name: 'coca colazx', category_id: category.id, user_id: test_user.id, amount: 3000) }
  let!(:item4) { Item.create(name: 'coca colaxsw', category_id: category.id, user_id: test_user.id, amount: 4000) }

  let!(:item5) { Item.create(name: 'coca asiimwe', category_id: category.id, user_id: test_user2.id, amount: 3000) }
  let!(:item6) { Item.create(name: 'asiimwe coke', category_id: category.id, user_id: test_user2.id, amount: 4000) }

  let(:category_id) { category.id }
  let(:id) { item1.id }

  describe 'GET /categories/:category_id/items' do
    before { get "/categories/#{category_id}/items", params: {}, headers: headers }

    context 'when category exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all category items' do
        expect(json.size).to eq(4)
      end
    end

    context 'when category does not exist' do
      let(:category_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(Message.not_found)
      end
    end
  end

  describe 'GET /categories/:category_id/items/:id' do
    before { get "/categories/#{category_id}/items/#{id}", params: {}, headers: headers }

    context 'when category item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when category item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(Message.not_found)
      end
    end
  end

  describe 'POST /categories/:category_id/items' do
    let(:valid_attributes) { { name: 'soda', amount: 1000 }.to_json }

    context 'when request attributes are valid' do
      before { post "/categories/#{category_id}/items", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/categories/#{category_id}/items", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /categories/:category_id/items/:id' do
    let(:valid_attributes) { { name: 'drink xyz' }.to_json }

    before { put "/categories/#{category_id}/items/#{id}", params: valid_attributes, headers: headers }

    context 'when item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates and returns the item' do
        expect(json['name']).to match(/drink xyz/)
      end
    end

    context 'when the item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(Message.not_found)
      end
    end
  end

  describe 'DELETE /categories/:category_id/items/:id' do
    before { delete "/categories/#{category_id}/items/#{id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns deleted item' do
      expect(json['name']).to eq('coca cola')
    end

    context 'when the record does not exist' do
      before { delete "/categories/#{category_id}/items/#{id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
