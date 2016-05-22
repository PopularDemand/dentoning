if Rails.env.production?
	CarrierWave.configure do |config|
		# Configuration for Amazon S3
		config.fog_credentials = {
			:provider							 => 'AWS',
			:aws_access_key_id		 => ENV['S3_ACCESS_KEY'],
			:aws_secret_access_key => ENV['S3_SECRET_KEY']
		}
		config.fog_directory 		 = ENV['S3_BUCKET']
	end
end

# Some users may have to add :region => ENV[’S3_REGION’] to the fog credentials,
# followed by heroku config:set S3_REGION=<bucket region> at the command line, where the bucket
# region should be something like ’eu-central-1’, depending on your location