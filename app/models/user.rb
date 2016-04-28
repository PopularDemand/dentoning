class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	before_save { email.downcase! } # "self" optional on right hand side
	
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }
			# Added index to emails via migration to ensure uniqueness
	validates :password, presence: true, length: { minimum: 6 }

	has_secure_password # requires model to have "password_digest" attribute
end