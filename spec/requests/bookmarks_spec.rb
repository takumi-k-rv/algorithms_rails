require 'rails_helper'

RSpec.describe 'Algorithms', type: :request do

  let!(:test_user) {FactoryBot.create(:user)}
  let!(:test_post) {FactoryBot.create(:post)}
  let!(:bookmark) {FactoryBot.build(:bookmark, user: test_user, post: test_post)}

  # POST /bookmarks/:post_id/create
  describe 'POST /bookmarks/:post_id/create' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: test_user.id)
      }

      it 'returns status code 302' do
        post "/bookmarks/#{test_post.id}/create"
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts/:post_id' do
        post "/bookmarks/#{test_post.id}/create"
        expect(response).to redirect_to("/posts/#{test_post.id}")
      end

      it 'save the new bookmark' do
        expect{post "/bookmarks/#{test_post.id}/create"}.to change(Bookmark, :count).by(1)
      end

    end

    context 'user is not logged in' do
      before {
         post "/bookmarks/#{test_post.id}/create"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # POST /bookmarks/:post_id/destroy
  describe 'POST /bookmarks/:post_id/destroy' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: test_user.id)
      }
      let!(:bookmark) {FactoryBot.create(:bookmark, user: test_user, post: test_post)}

      it 'returns status code 302' do
        post "/bookmarks/#{test_post.id}/destroy"
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts/:post_id' do
        post "/bookmarks/#{test_post.id}/destroy"
        expect(response).to redirect_to("/posts/#{test_post.id}")
      end

      it 'save the new bookmark' do
        expect{post "/bookmarks/#{test_post.id}/destroy"}.to change(Bookmark, :count).by(-1)
      end

    end

    context 'user is not logged in' do
      before {
         post "/bookmarks/#{test_post.id}/create"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

end
