Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # later restrict to your web & mobile domains
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end
