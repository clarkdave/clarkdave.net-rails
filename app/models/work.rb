require 'rdiscount'

class Work < ActiveRecord::Base

	has_attached_file :image

	def get_image_size
		return {:x => 0, :y => 0} unless image.present?

		Paperclip::Geometry.from_file(image.to_file)
		#{:x => geom.width.to_i, :y => geom.height.to_i }
	end


	def html_description
		RDiscount.new(description).to_html
	end
end
