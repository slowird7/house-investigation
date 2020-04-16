Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://house-investigation.s3.amazonaws.com/'

    resource '*',
      headers: :any,
      methods: :any,
      credentials: true
  end
end