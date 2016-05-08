class User < ActiveRecord::Base
	attr_accessor :remember_token
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	before_save { self.email = email.downcase } # "self" optional on right hand side
	
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }
			# Added index to emails via migration to ensure uniqueness
	validates :password, presence: true, length: { minimum: 6 }

	has_secure_password # requires model to have "password_digest" attribute

	# Doesn't actually use a User object,
	# so just define as a class method (used like a module, like javascript)
	# Returns the hash digest of a given string
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token
	# call this elsewhere with "User.new_token"
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers what user logged into session
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Forgets user
	def forget
		update_attribute(:remember_digest, nil)
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		# This is a local variable not accessor
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
end