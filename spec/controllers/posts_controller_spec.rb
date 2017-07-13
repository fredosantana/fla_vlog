require 'rails_helper'

RSpec.describe PostsController, type: :controller do

	describe "posts#update" do
		it "should allow admins to successfully update posts" do
			post = FactoryGirl.create(:post, name: "Fredo")
			patch :update, params: { id: post.id, post: { name: 'Wayne' } }
			expect(response).to redirect_to root_path
			post.reload
			expect(post.name).to eq "Wayne"
		end

		it "should have http 404 error if the post cannot be found" do
			patch :update, params: { id: "VENUS", post: { name: 'Changed' } }
			expect(response).to have_http_status(:not_found)
		end

		it "should render the edit form with an http status of unprocessable_entity" do
			post = FactoryGirl.create(:post, name: "Initial Value")
			patch :update, params: { id: post.id, post: { name: ' '} }	
			#expect(response).to have_http_status(:unprocessable_entity)
			post.reload
			expect(post.name).to eq "Initial Value"
		end
	end

	describe "posts#edit action" do
		it "should successfully show the edit form if the post if found" do
			post = FactoryGirl.create(:post)
			get :edit, params: { id: post.id }
			expect(response).to have_http_status(:success)
		end

		it "should return a 404 error message if the post is not found" do
			get :edit, params: { id: 'TACOCAT'}
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "posts#show action" do
		it "should successfully show the page if the post is found" do
			post = FactoryGirl.create(:post)
			get :show, params: { id: post.id }
			expect(response).to have_http_status(:success)	
		end

		it "should return a 404 error if the post is not found" do
			get :show, params: { id: 'TACOCAT' }
			expect(response).to have_http_status(:not_found)
		end
	end

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
