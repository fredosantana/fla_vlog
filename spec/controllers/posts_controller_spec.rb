require 'rails_helper'

RSpec.describe PostsController, type: :controller do

	describe "posts#index action" do
  	it "should successfully show the page" do
  		get :index
  		expect(response).to have_http_status(:success)
  	end
	end

	describe "posts#new action" do
		it "should require admins to be logged in" do
			get :new
			expect(response).to redirect_to new_admin_session_path
		end

		it "should successfully show the new form" do
			admin = FactoryGirl.create(:admin)
  		sign_in admin

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "posts#create action" do
		it "should require admins to be logged in" do
			post :create, params: { post: { message: "Hi" } }
			expect(response).to redirect_to new_admin_session_path
		end

		it "should successfully create a new post in our database" do
			admin = FactoryGirl.create(:admin)
  		sign_in admin

			post :create, params: { post: { name: 'FREDO!!' } }
			expect(response).to redirect_to root_path

			post = Post.last
			expect(post.name).to eq("FREDO!!")
			expect(post.admin).to eq(admin)
		end

		it "should properly deal with validation errors" do
			admin = FactoryGirl.create(:admin)
  		sign_in admin

			post_count = Post.count
			post :create, params: { post: { name: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(post_count).to eq Post.count
		end
	end
end
