class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
					 # Find this user by the foreign key follower
	has_many :active_relationships,  class_name:  "Relationship",
																	 foreign_key: "follower_id",
																	 dependent:   :destroy
	has_many :passive_relationships, class_name:  "Relationship",
																	 foreign_key: "followed_id",
																	 dependent:   :destroy
								# source: get the followed ids relating to a foreign key, follower id, of this user
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	# use attr_accessor for virtual attributes (not in db)
	attr_accessor :remember_token, :activation_token, :reset_token
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	# "Rails, go find this function and run it before you create"
	before_save :downcase_email
	before_create :create_activation_digest
	
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX },
				# Added index to emails via migration to ensure uniqueness
										uniqueness: { case_sensitive: false }
				# allow nil only allows nil on updating the profile. has_secure_password doesn't allow on sign up
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest") # officially, don't need 'self'
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)

		## This is rewritten to accomodate account activation token
		# return false if remember_digest.nil?
		# # This is a local variable not accessor
		# BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Activate account
	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
		# update_columns(:activated,    true)
		# update_attribute(:activated_at, Time.zone.now)
	end

	# Send activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# Sets the password reset attributes
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(reset_digest:  User.digest(reset_token),
									 reset_sent_at: Time.zone.now)
		# update_attribute(:reset_digest, User.digest(reset_token))
		# update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends password reset email
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if password reset is expired
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	# Feed
	def feed
		Micropost.where("user_id = ?", id)
	end

	# Follows a user
	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	# Unfollows a user
	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	# Returns true if current user is following the other user
	def following?(other_user)
		following.include?(other_user)
	end

	private
		def downcase_email
			self.email = email.downcase
		end

		def create_activation_digest
			self.activation_token  = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end