require 'rails_helper'

RSpec.describe 'Algorithms', type: :request do

  let!(:user) {FactoryBot.create(:user)}
  let!(:posts) {FactoryBot.create_list(:post, 10, user: user)}
  let(:test_post) {posts.first}
  let(:post_id) {posts.first.id}

  # GET /posts
  describe 'GET /posts' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get '/posts'
      }

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders index.html.erb' do
        expect(response).to render_template("posts/index")
      end

      it 'assigns to posts' do
        expect(assigns(:posts)).to eq(posts)
      end
    end

    # context 'user is not logged in' do
    #   before {
    #     get '/posts'
    #   }
    #   it 'returns status code 302' do
    #     expect(response.status).to eq(302)
    #   end

    #   it 'redirect to /login' do
    #     expect(response).to redirect_to("/login");
    #   end
    # end

  end

  # GET /posts/:id
  describe 'GET /posts/:id' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/posts/#{post_id}"
      }

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders show.html.erb' do
        expect(response).to render_template("posts/show")
      end

      it 'assigns to post' do
        expect(assigns(:post)).to eq(test_post)
      end
    end

    # context 'user is not logged in' do
    #   before {
    #     get "/posts/#{post_id}"
    #   }
    #   it 'returns status code 302' do
    #     expect(response.status).to eq(302)
    #   end

    #   it 'redirect to /login' do
    #     expect(response).to redirect_to("/login")
    #   end
    # end

  end

  # GET /posts/new
  describe 'GET /posts/new' do
    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/posts/new"
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders new.html.erb' do
        expect(response).to render_template("posts/new")
      end
    end

    context 'user is not logged in' do
      before {
        get "/posts/new"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # GET /posts/:id/edit
  describe 'GET /posts/:id/edit' do
    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/posts/#{post_id}/edit"
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders edit.html.erb' do
        expect(response).to render_template("posts/edit")
      end

      it 'assigns to post' do
        expect(assigns(:post)).to eq(test_post)
      end
    end

    context 'user is not logged in' do
      before {
        get "/posts/#{post_id}/edit"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # POST /posts
  describe 'POST /posts' do

    let(:new_post) {FactoryBot.build(:new_post)}
    let(:normal_params) do
      { params: {title: new_post.title, content: new_post.content, code: new_post.code} }
    end
    let(:abnormal_params) do
      { params: {title: new_post.title, content: nil, code: nil} }
    end

    context 'user is logged in && normal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        post "/posts", normal_params
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts/:id' do
        post "/posts", normal_params
        expect(response).to redirect_to("/posts/#{assigns(:post).id}")
      end

      it 'saved the new post' do
        expect{post "/posts", normal_params}.to change(Post, :count).by(1)
      end

      it 'assign to created post' do
        post "/posts", normal_params
        expect(assigns(:post).title).to eq(new_post.title)
        expect(assigns(:post).content).to eq(new_post.content)
        expect(assigns(:post).code).to eq(new_post.code)
      end
    end

    context 'user is logged in && abnormal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 200' do
        post "/posts", abnormal_params
        expect(response.status).to eq(200)
      end

      it 'renders new.html.erb' do
        post "/posts", abnormal_params
        expect(response).to render_template("posts/new")
      end

      it 'unsaved the new post' do
        expect{post "/posts", abnormal_params}.to change(Post, :count).by(0)
      end

    end

    context 'user is not logged in' do
      before {
        post "/posts", normal_params
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        post "/posts", normal_params
        expect(response).to redirect_to("/login")
      end
    end
  end

  # PATCH /posts/:id
  describe 'PATCH /posts/:id' do

    let(:new_post) {FactoryBot.build(:new_post)}
    let(:normal_params) do
      { params: {title: new_post.title, content: new_post.content, code: new_post.code} }
    end
    let(:abnormal_params) do
      { params: {title: new_post.title, content: nil, code: nil} }
    end

    context 'user is logged in && normal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        patch "/posts/#{post_id}", normal_params
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts/:id' do
        patch "/posts/#{post_id}", normal_params
        expect(response).to redirect_to("/posts/#{assigns(:post).id}")
      end

      it 'updated the new post' do
        old_title = test_post.title
        patch "/posts/#{post_id}", normal_params
        expect(test_post.reload.title).to_not eq(old_title)
      end

      it 'assign to updated post' do
        patch "/posts/#{post_id}", normal_params
        expect(assigns(:post).title).to eq(new_post.title)
        expect(assigns(:post).content).to eq(new_post.content)
        expect(assigns(:post).code).to eq(new_post.code)
      end
    end

    context 'user is logged in && abnormal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 200' do
        patch "/posts/#{post_id}", abnormal_params
        expect(response.status).to eq(200)
      end

      it 'renders edit.html.erb' do
        patch "/posts/#{post_id}", abnormal_params
        expect(response).to render_template("posts/edit")
      end

      it 'did not update the new post' do
        old_title = test_post.title
        patch "/posts/#{post_id}", abnormal_params
        expect(test_post.reload.title).to eq(old_title)
      end

    end

    context 'user is not logged in' do
      before {
        patch "/posts/#{post_id}", normal_params
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # DELETE /posts/:id
  describe 'DELETE /posts/:id' do
    context 'user is logged in' do
      before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id) }
      it 'returns status code 302' do
        delete "/posts/#{post_id}"
        expect(response.status).to eq(302)
      end

      it 'redirect to /users/user_id' do
        delete "/posts/#{post_id}"
        expect(response).to redirect_to("/users/#{session[:user_id]}")
      end

      it 'destroy the post' do
        expect{delete "/posts/#{post_id}"}.to change(Post, :count).by(-1)
      end
    end

    context 'user is not logged in' do
      it 'returns status code 302' do
        delete "/posts/#{post_id}"
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        delete "/posts/#{post_id}"
        expect(response).to redirect_to("/login")
      end
    end
  end

end
