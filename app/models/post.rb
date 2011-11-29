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

	private
	def create_slug
		self.slug = self.title.try(:parameterize) if self.new_record?
	end
	
end
