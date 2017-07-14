require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#create action" do
		it "should allow admins to create comments on posts" do
		end

		it "should require an admin to be logged in to comment on a post" do
		end

		it "should return http status code of not found if the post isn't found" do
		end
	end
end
