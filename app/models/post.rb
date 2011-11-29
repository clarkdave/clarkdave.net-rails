require 'rdiscount'

class Post < ActiveRecord::Base

	validates :user_id, :presence => true
	validates :title, :presence => true,
					  :length => { :minimum => 5 }
	# TODO: add validation for content and stuff

	belongs_to :user

	before_validation :create_slug

	def to_param
		slug
	end

	# get html for just the snippet (for front page)
	def html_snippet
		RDiscount.new(snippet).to_html
	end

	# get html for both snippet and content together
	def html_all
		RDiscount.new(snippet + "\n\n" + content).to_html
	end

	private
	def create_slug
		self.slug = self.title.try(:parameterize) if self.new_record?
	end
	
end
