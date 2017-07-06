class PostsController < ApplicationController
	def new
		@post = Post.new
	end

	def create
		@post = Post.create(post_params)
		redirect_to root_path
	end

	def index
	end

	private

	def post_params
		params.require(:post).permit(:name)
	end

end
