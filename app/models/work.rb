require 'rdiscount'

class Work < ActiveRecord::Base

	has_attached_file :image

	def get_image_size
		return {:x => 0, :y => 0} unless image.present?

		Paperclip::Geometry.from_file(image.to_file)
		#{:x => geom.width.to_i, :y => geom.height.to_i }
	end

	def banner_thumb_url

		return nil unless image.exists?

		path = image.path.sub /(\.[^\?]+)/, '_banner.jpg'

		return nil unless File.exists(path)

		image.url.sub /(\.[^\?]+)/, '_banner.jpg'
	end

	def mini_thumb_url
		
		return nil unless image.exists?

		path = image.path.sub /(\.[^\?]+)/, '_mini.jpg'

		return nil unless File.exists(path)

		image.url.sub /(\.[^\?]+)/, '_mini.jpg'
	end


	def html_description
		RDiscount.new(description).to_html
	end
end
