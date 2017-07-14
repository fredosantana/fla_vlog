require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#create action" do
		it "should allow admins to create comments on posts" do
			
			message = FactoryGirl.create(:post)

  		admin = FactoryGirl.create(:admin)
  		sign_in admin

  		post :create, params: { post_id: message.id, comment: { message: 'awesome post' } }

			expect(response).to redirect_to root_path
  		expect(message.comments.length).to eq 1
  		expect(message.comments.first.message).to eq "awesome post"
		end

		it "should require an admin to be logged in to comment on a post" do
			message = FactoryGirl.create(:post)
  		post :create, params: { post_id: message.id, comment: { message: 'awesome post' } }
  		expect(response).to redirect_to new_admin_session_path	
		end

		it "should return http status code of not found if the post isn't found" do
			admin = FactoryGirl.create(:admin)
			sign_in admin
			post :create, params: { post_id: 'SUNSHINE', comment: { message: 'awesome post'} }
			expect(response).to have_http_status :not_found
		end
	end
end
