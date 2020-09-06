require 'rails_helper'

RSpec.describe 'Algorithms', type: :request do

  # let!(:users) { [FactoryBot.create(:admin_user), FactoryBot.create(:user)] }
  let!(:users) { FactoryBot.create_list(:admin_user,1).concat(FactoryBot.create_list(:user,9)) }
  let(:admin_user) {users.first}
  let!(:user) {users.second}
  let!(:other_user) {users.third}

  # GET /users
  describe 'GET /users' do

    context 'user is admin' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: admin_user.id)
        get '/users'
      }

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders index.html.erb' do
        expect(response).to render_template("users/index")
      end

      it 'assigns to users' do
        expect(assigns(:users)).to eq(users)
      end
    end

    context 'user is not logged in' do
      before {
        get '/users'
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login");
      end
    end

  end

  # GET /users/:id
  describe 'GET /users/:id' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/users/#{user.id}"
      }

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders show.html.erb' do
        expect(response).to render_template("users/show")
      end

      it 'assigns to user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    # context 'user is not logged in' do
    #   before {
    #     get "/users/#{user.id}"
    #   }
    #   it 'returns status code 302' do
    #     expect(response.status).to eq(302)
    #   end

    #   it 'redirect to /login' do
    #     expect(response).to redirect_to("/login")
    #   end
    # end

  end

  # GET /users/new
  describe 'GET /users/new' do
    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/users/new"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        expect(response).to redirect_to("/posts")
      end
    end

    context 'user is not logged in' do
      before {
        get "/users/new"
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders new.html.erb' do
        expect(response).to render_template("users/new")
      end
    end
  end

  # GET /users/:id/edit
  describe 'GET /users/:id/edit' do
    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/users/#{user.id}/edit"
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders edit.html.erb' do
        expect(response).to render_template("users/edit")
      end

      it 'assigns to user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'user is logged in && wanna edit other user\'s one' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get "/users/#{other_user.id}/edit"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        expect(response).to redirect_to("/posts")
      end

    end

    context 'user is not logged in' do
      before {
        get "/users/#{user.id}/edit"
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # POST /users
  describe 'POST /users' do

    let(:new_user) {FactoryBot.build(:new_user)}
    let(:normal_params) do
      { params: {name: new_user.name, email: new_user.email, password: new_user.password} }
    end
    let(:abnormal_params1) do # name is nil
      { params: {name: nil, email: new_user.email, password: new_user.password} }
    end
    let(:abnormal_params2) do # email is not unique
      { params: {name: new_user.name, email: user.email, password: new_user.password} }
    end

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        post "/users", normal_params
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        post "/users", normal_params
        expect(response).to redirect_to("/posts")
      end
    end

    context 'user is not logged in && normal data' do

      it 'returns status code 302' do
        post "/users", normal_params
        expect(response.status).to eq(302)
      end

      it 'redirect to /users/:id' do
        post "/users", normal_params
        expect(response).to redirect_to("/users/#{assigns(:user).id}")
      end

      it 'saved the new user' do
        expect{post "/users", normal_params}.to change(User, :count).by(1)
      end

      it 'assign to created user' do
        post "/users", normal_params
        expect(assigns(:user).name).to eq(new_user.name)
        expect(assigns(:user).email).to eq(new_user.email)
        expect(assigns(:user).password).to eq(new_user.password)
      end
    end

    context 'user is not logged in && abnormal data 1' do

      it 'returns status code 302' do
        post "/users", abnormal_params1
        expect(response.status).to eq(302)
      end

      it 'redirect_to /users/new' do
        post "/users", abnormal_params1
        expect(response).to redirect_to("/users/new")
      end

      it 'unsaved the new user' do
        expect{post "/users", abnormal_params1}.to change(Post, :count).by(0)
      end
    end

    context 'user is not logged in && abnormal data 2' do

      it 'returns status code 302' do
        post "/users", abnormal_params2
        expect(response.status).to eq(302)
      end

      it 'redirect_to /users/new' do
        post "/users", abnormal_params2
        expect(response).to redirect_to("/users/new")
      end

      it 'unsaved the new user' do
        expect{post "/users", abnormal_params2}.to change(Post, :count).by(0)
      end
    end
  end

  # PATCH /users/:id
  describe 'PATCH /users/:id' do

    let(:new_user) {FactoryBot.build(:new_user)}
    let(:normal_params) do
      { params: {name: new_user.name, email: new_user.email, password: new_user.password} }
    end
    let(:abnormal_params1) do # name is nil
      { params: {name: nil, email: new_user.email, password: new_user.password} }
    end

    context 'user is logged in && normal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        patch "/users/#{user.id}", normal_params
        expect(response.status).to eq(302)
      end

      it 'redirect to /users/:id' do
        patch "/users/#{user.id}", normal_params
        expect(response).to redirect_to("/users/#{assigns(:user).id}")
      end

      it 'updated the new user' do
        old_name = user.name
        patch "/users/#{user.id}", normal_params
        expect(user.reload.name).to_not eq(old_name)
      end

      it 'assign to updated user' do
        patch "/users/#{user.id}", normal_params
        expect(assigns(:user).name).to eq(new_user.name)
        expect(assigns(:user).email).to eq(new_user.email)
      end
    end

    context 'user is logged in && abnormal data 1' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        patch "/users/#{user.id}", abnormal_params1
        expect(response.status).to eq(302)
      end

      it 'redirect_to /users/edit' do
        patch "/users/#{user.id}", abnormal_params1
        expect(response).to redirect_to("/users/#{user.id}/edit")
      end

      it 'did not update the new user' do
        old_name = user.name
        patch "/users/#{user.id}", abnormal_params1
        expect(user.reload.name).to eq(old_name)
      end
    end

    context 'user is logged in && wanna update other user && normal data' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        patch "/users/#{other_user.id}", normal_params
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        patch "/users/#{other_user.id}", normal_params
        expect(response).to redirect_to("/posts")
      end

      it 'did not update the new user' do
        old_name = user.name
        patch "/users/#{other_user.id}", normal_params
        expect(user.reload.name).to eq(old_name)
      end
    end

    context 'user is not logged in' do
      before {
        patch "/users/#{user.id}", normal_params
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end
  end

  # DELETE /users/:id
  describe 'DELETE /users/:id' do
    context 'user is logged in' do
      before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id) }
      it 'returns status code 302' do
        delete "/users/#{user.id}"
        expect(response.status).to eq(302)
      end

      it 'redirect to /' do
        delete "/users/#{user.id}"
        expect(response).to redirect_to("/")
      end

      it 'destroy the user' do
        expect{delete "/users/#{user.id}"}.to change(User, :count).by(-1)
      end
    end

    context 'user is logged in && wanna destroy other user' do

      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
      }

      it 'returns status code 302' do
        delete "/users/#{other_user.id}"
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        delete "/users/#{other_user.id}"
        expect(response).to redirect_to("/posts")
      end

      it 'did not destroy the user' do
        expect{delete "/users/#{other_user.id}"}.to change(User, :count).by(0)
      end
    end

    context 'user is not logged in' do
      it 'returns status code 302' do
        delete "/users/#{user.id}"
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        delete "/users/#{user.id}"
        expect(response).to redirect_to("/login")
      end
    end
  end

  # GET /login
  describe 'GET /login' do
    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        get '/login'
      }

      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        expect(response).to redirect_to("/posts")
      end
    end

    context 'user is not logged in' do
      before {
        get '/login'
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'renders login_form.html.erb' do
        expect(response).to render_template("users/login_form")
      end
    end
  end

  # POST /login
  describe 'POST /login' do
    let(:correct_params) do
      { params: {email: user.email, password: user.password} }
    end
    let(:wrong_params) do # wrong password
      { params: {email: user.email, password: "wrong"} }
    end

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        post '/login', correct_params
      }

      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        expect(response).to redirect_to("/posts")
      end
    end

    context 'user is not logged in && correct_params' do
      before {
        post '/login', correct_params
      }
      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /posts' do
        expect(response).to redirect_to("/posts")
      end

      it 'assign to user' do
        expect(assigns(:user)).to eq(user)
      end

    end

    context 'user is not logged in && wrong_params' do
      before {
        post '/login', wrong_params
      }
      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'redirect to /posts' do
        expect(response).to render_template("users/login_form")
      end
    end
  end

  # POST /logout
  describe 'POST /logout' do

    context 'user is logged in' do
      before {
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
        post '/logout'
      }

      it 'returns status code 302' do
        expect(response.status).to eq(302)
      end

      it 'redirect to /login' do
        expect(response).to redirect_to("/login")
      end
    end

    context 'user is not logged in' do
      before {
        post '/logout'
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
