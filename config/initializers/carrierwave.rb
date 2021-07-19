require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# Carrierwave のファイル名に日本語を許可する
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
 
CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :file
#    config.storage :fog
#    config.cache_storage = :fog # キャッシュにS3を指定

    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'house-investigation3'
#    config.asset_host = 'https://s3-' + ENV['AWS_DEFAULT_REGION'] + '.amazonaws.com/house-investigation3'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_DEFAULT_REGION'],
      path_style: true
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end