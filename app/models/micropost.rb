class Micropost < ActiveRecord::Base
  belongs_to :user
  								 # is a Proc
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  # mount uploader to db attribute picture, the uploader is PictureUploader
  mount_uploader :picture, PictureUploader

  private

  	# Validates the size of an uploaded picture
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
end
