class PostsController < ApplicationController

	before_filter :authenticate, :except => [
		:index, :show
	]

	def authenticate
		redirect_to posts_path if not logged_in?
	end

	# GET /posts
	def index
		#@posts = logged_in? ? Post.order('created_at DESC') : Post.where(:published => true).order('created_at DESC')

		# normal users only see published posts
		@posts = (logged_in? ? Post : Post.where(:published => true)).order('created_at DESC')

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @posts }
		end
	end

	# GET /posts/post-title-slug
	def show
		@post = Post.find_by_slug!(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @post }
		end
	end

	# GET /posts/new
	def new
		@post = Post.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @post }
		end
	end

	# GET /posts/1/edit
	def edit
		@post = Post.find_by_slug!(params[:id])
	end

	# POST /posts
	def create
		@post = Post.new(params[:post])

		respond_to do |format|
			if @post.save
				format.html { redirect_to @post, notice: 'Post was successfully created.' }
				format.json { render json: @post, status: :created, location: @post }
			else
				format.html { render action: "new" }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /posts/1
	def update
		@post = Post.find(params[:id])

		respond_to do |format|
			if @post.update_attributes(params[:post])
				format.html { redirect_to @post, notice: 'Post was successfully updated.' }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /posts/1
	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		respond_to do |format|
			format.html { redirect_to posts_url }
			format.json { head :ok }
		end
	end
end
