require 'rails_helper'

RSpec.describe PostsController, type: :controller do

	describe "posts#index action" do
  	it "should successfully show the page" do
  		get :index
  		expect(response).to have_http_status(:success)
  	end
	end

	describe "posts#new action" do
		it "should successfully show the new form" do
			admin = Admin.create(
    		email:                 'fakeuser@gmail.com',
    		password:              'secretPassword',
    		password_confirmation: 'secretPassword'
  		)
  	sign_in admin

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "posts#create action" do
		it "should successfully show the new form" do
			admin = Admin.create(
    		email:                 'fakeuser@gmail.com',
    		password:              'secretPassword',
    		password_confirmation: 'secretPassword'
  		)
  	sign_in admin
  	
			post :create, params: { post: { name: 'FREDO!!' } }
			expect(response).to redirect_to root_path

			post = Post.last
			expect(post.name).to eq("FREDO!!")
			expect(post.admin).to eq(admin)
		end

		it "should successfully show the new form" do
			admin = Admin.create(
    		email:                 'fakeuser@gmail.com',
    		password:              'secretPassword',
    		password_confirmation: 'secretPassword'
  		)
  	sign_in admin

			post :create, params: { post: { name: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(Post.count).to eq 0
		end
	end
end
