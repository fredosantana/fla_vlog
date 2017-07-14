class PostsController < ApplicationController
	before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

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
		@posts = Post.all
	end

	def show
		@post = Post.find_by_id(params[:id])
		return render_not_found if @post.blank?
	end

	def edit
		@post = Post.find_by_id(params[:id])
		return render_not_found if @post.blank?
		return render_not_found(:forbidden) if @post.admin != current_admin
	end

	def destroy
		@post = Post.find_by_id(params[:id])
		return render_not_found if @post.blank?
		return render_not_found(:forbidden) if @post.admin != current_admin
		@post.destroy
		redirect_to root_path
	end

	def update
		@post = Post.find_by_id(params[:id])
		return render_not_found if @post.blank?
		return render_not_found(:forbidden) if @post.admin != current_admin
		
		@post.update_attributes(post_params)
		
		if @post.valid?
			redirect_to root_path
		else
			return render :edit, status: :unprocessable_entity
		end
	end

	private

	def post_params
		params.require(:post).permit(:name, :description, :address, :picture)
	end

	def render_not_found(status=:not_found)
		render plain: "#{status.to_s.titleize} :(", status: status
	end

end
