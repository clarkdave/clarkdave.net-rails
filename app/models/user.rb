require 'bcrypt'

class User < ActiveRecord::Base

	attr_accessor :password
	attr_accessible :email, :password, :password_confirmation

	validates :email, :uniqueness => true, :presence => true
	validates :password, :presence => true,
						 :confirmation => true,
						 :length => { :within => 5..60 },
						 :on => :create

	before_save :encrypt_password

	has_many :posts

	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.pass == BCrypt::Engine.hash_secret(password, user.salt)
			user
		else
			nil
		end
	end

	private
	def encrypt_password
		if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.pass = BCrypt::Engine.hash_secret(password, self.salt)
		end
	end

end
