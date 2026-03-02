# Rails Admin Configuration Helper
# This file contains any additional setup needed for Rails Admin to work properly

# Ensure Rails Admin loads after Devise
Rails.application.config.after_initialize do
  RailsAdmin.config do |config|
    # Additional configuration can be added here if needed
  end
end
