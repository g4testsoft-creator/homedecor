# Allow cross-origin requests
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Frontend domain(s)
    origins 'http://localhost:4000', 'https://your-frontend.vercel.app'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true  # if you need cookies/session
  end
end