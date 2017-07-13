class PostsController < ApplicationController
	before_action :authenticate_admin!, only: [:new, :create]

	def new
		@post = Post.new
	end

	def create
		@post = current_admin.posts.create(post_params)
		if @post.valid?
			redirect_to root_path
		else
			render :new, status: :unprocessable_entity
		end
	end

	def index
	end

	def show
		@post = Post.find_by_id(params[:id])
		if @post.blank?
			render plain: 'Not Found :(', status: :not_found
		end
	end

	private

	def post_params
		params.require(:post).permit(:name)
	end

end
