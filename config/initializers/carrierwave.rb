CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage                             = :gcloud
    config.gcloud_bucket                       = ENV['GCLOUD_BUCKET']
    config.gcloud_bucket_is_public             = false
    config.gcloud_authenticated_url_expiration = 1800
    config.gcloud_content_disposition          = 'attachment'          # or you can skip this

    config.gcloud_attributes = {
      expires: 1800
    }

    config.gcloud_credentials = {
      gcloud_project: ENV['GCLOUD_PROJECT'],
      gcloud_keyfile: JSON.parse(ENV['GCLOUD_KEYFILE'] || "null")
    }
  else
    config.storage = :file
  end
end
