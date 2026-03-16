# config/initializers/stripe.rb
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

# For logging Stripe events in development
if Rails.env.development?
  Stripe.log_level = Stripe::LEVEL_INFO
end