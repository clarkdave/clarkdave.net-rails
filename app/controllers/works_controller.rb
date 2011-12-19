class WorksController < ApplicationController
	# GET /works
	# GET /works.json
	def index
		@works = Work.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @works }
		end
	end

	# GET /works/1
	# GET /works/1.json
	def show
		@work = Work.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @work }
		end
	end

	# GET /works/new
	# GET /works/new.json
	def new
		@work = Work.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @work }
		end
	end

	# GET /works/1/edit
	def edit
		@work = Work.find(params[:id])
	end

	# POST /works
	# POST /works.json
	def create
		@work = Work.new(params[:work])

		respond_to do |format|
			if @work.save
				format.html { redirect_to @work, notice: 'Work was successfully created.' }
				format.json { render json: @work, status: :created, location: @work }
			else
				format.html { render action: "new" }
				format.json { render json: @work.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /works/1
	# PUT /works/1.json
	def update
		@work = Work.find(params[:id])

		respond_to do |format|
			if @work.update_attributes(params[:work])
				format.html { redirect_to @work, notice: 'Work was successfully updated.' }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @work.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /works/1
	# DELETE /works/1.json
	def destroy
		@work = Work.find(params[:id])
		@work.destroy

		respond_to do |format|
			format.html { redirect_to works_url }
			format.json { head :ok }
		end
	end

	# POST /works
	def create_thumb
		@work = Work.find(params[:id])

		render :status => 501 if @work.nil?

		#puts @work.image.to_file.path
		
		size = @work.get_image_size
		width = size.width
		height = size.height
		new_path = @work.image.to_file.path.sub /(\..+)$/, "_#{params['type']}.jpg"

		#puts params
		#puts new_path
		
		Devil.with_image(@work.image.to_file.path) do |img|

			if params['scale'].to_i < 100 then
				scale = params['scale'].to_f / 100
				width = (width * scale).to_i
				height = (height * scale).to_i
				img.resize(width, height, :filter => Devil::SCALE_BSPLINE)
			end
			
			# for some reason the 2nd param, yoff, appears to count from the bottom of the image rather
			# than (as you'd think) the top... weird
			img.crop params['pos_x'].to_i, height - params['pos_y'].to_i - params['height'].to_i, 
				params['width'].to_i, params['height'].to_i
			img.save(new_path)

		end

		render :nothing => true

	end
end
