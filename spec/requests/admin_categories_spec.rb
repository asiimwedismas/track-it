require 'rails_helper'

RSpec.describe 'Admin Categories API', type: :request do
  let!(:category1) { Category.create(title: 'abc') }
  let!(:category2) { Category.create(title: 'abd') }
  let!(:category3) { Category.create(title: 'abe') }
  let(:test_categoryid) { category1.id }

  describe 'Given user is not an admin' do
    let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password', is_admin: false) }
    let(:headers) { valid_headers }

    describe 'GET /admin/categories' do
      before { get '/admin/categories', params: {}, headers: headers }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'POST /admin/categories' do
      let(:valid_attributes) { { title: 'Computers' }.to_json }

      context 'when the request is valid' do
        before { post '/admin/categories', params: valid_attributes, headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when the request is invalid' do
        before { post '/admin/categories', params: {}, headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'PUT /admin/categories/:id' do
      let(:valid_attributes) { { title: 'updated category title' }.to_json }

      context 'when the record exists' do
        before { put "/admin/categories/#{test_categoryid}", params: valid_attributes, headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'DELETE /admin/categories/:id' do
      context 'when the record exists' do
        before { delete "/admin/categories/#{test_categoryid}", headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when the record does not exist' do
        before { delete '/admin/categories/1000', headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe 'Given user is an admin' do
    let(:test_user) { User.create(name: 'dismas', email: 'email@email.com', password: 'password', is_admin: true) }
    let(:headers) { valid_headers }

    describe 'GET /admin/categories' do
      before { get '/admin/categories', params: {}, headers: headers }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns categories' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)
      end
    end

    describe 'POST /admin/categories' do
      let(:valid_attributes) { { title: 'Computers' }.to_json }

      context 'when the request is valid' do
        before { post '/admin/categories', params: valid_attributes, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates and returns the new category' do
          expect(json['title']).to eq('Computers')
        end
      end

      context 'when the request is invalid' do
        before { post '/admin/categories', params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it "returns message => Validation failed: Title can't be blank, Title is too short (minimum is 2 characters)" do
          expect(json['message'])
            .to match("Validation failed: Title can't be blank, Title is too short (minimum is 2 characters)")
        end
      end
    end

    describe 'PUT /admin/categories/:id' do
      let(:valid_attributes) { { title: 'updated category title' }.to_json }

      context 'when the record exists' do
        before { put "/admin/categories/#{test_categoryid}", params: valid_attributes, headers: headers }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'updates and returns the updated category' do
          expect(json['title']).to eq('updated category title')
        end
      end
    end

    describe 'DELETE /admin/categories/:id' do
      context 'when the record exists' do
        before { delete "/admin/categories/#{test_categoryid}", headers: headers }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns deleted category' do
          expect(json['title']).to eq('abc')
        end
      end

      context 'when the record does not exist' do
        before { delete '/admin/categories/1000', headers: headers }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
