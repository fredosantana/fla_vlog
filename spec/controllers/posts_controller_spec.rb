require 'rails_helper'

RSpec.describe PostsController, type: :controller do

	describe "posts#destroy action" do
		it "shouldn't let unauthenticated admins destroy a post" do
			post = FactoryGirl.create(:post)
			delete :destroy, params: { id: post.id }
			expect(response).to redirect_to new_admin_session_path
		end

		it "should allow an admin to destroy a post" do
			post = FactoryGirl.create(:post)
			sign_in post.admin
			delete :destroy, params: { id: post.id }
			expect(response).to redirect_to root_path
			post = Post.find_by_id(post.id)
			expect(post).to eq nil
		end

		it "should return a 404 message if we cannot find a post with the id that is specified" do
			admin = FactoryGirl.create(:admin)
			sign_in admin
			delete :destroy, params: { id: 'RUPAUL'}
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "posts#update" do
		it "shouldn't let unauthenticated admins create a post" do
			post = FactoryGirl.create(:post)
			patch :update, params: { id: post.id, post: { name: "Fredo" } }
			expect(response).to redirect_to new_admin_session_path
		end

		it "should allow admins to successfully update posts" do
			post = FactoryGirl.create(:post, name: "Fredo")
			sign_in post.admin

			patch :update, params: { id: post.id, post: { name: 'Wayne' } }
			expect(response).to redirect_to root_path
			post.reload
			expect(post.name).to eq "Wayne"
		end

		it "should have http 404 error if the post cannot be found" do
			admin = FactoryGirl.create(:admin)
			sign_in admin

			patch :update, params: { id: "VENUS", post: { name: 'Changed' } }
			expect(response).to have_http_status(:not_found)
		end

		it "should render the edit form with an http status of unprocessable_entity" do
			post = FactoryGirl.create(:post, name: "Initial Value")
			sign_in post.admin

			patch :update, params: { id: post.id, post: { name: ' '} }	
			#expect(response).to have_http_status(:unprocessable_entity)
			post.reload
			expect(post.name).to eq "Initial Value"
		end
	end

	describe "posts#edit action" do
		it "shouldn't let an admin who did not create the post edit a post" do
			post = FactoryGirl.create(:post)
			admin = FactoryGirl.create(:admin)
			sign_in admin
			get :edit, params: { id: post.id }
			expect(response).to have_http_status(:forbidden)
		end

		it "shouldn't let unauthenticated admins edit a post" do
			post = FactoryGirl.create(:post)
			get :edit, params: { id: post.id }
			expect(response).to redirect_to new_admin_session_path
		end

		it "should successfully show the edit form if the post if found" do
			post = FactoryGirl.create(:post)
			sign_in post.admin

			get :edit, params: { id: post.id }
			expect(response).to have_http_status(:success)
		end

		it "should return a 404 error message if the post is not found" do
			admin = FactoryGirl.create(:admin)
			sign_in admin

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
