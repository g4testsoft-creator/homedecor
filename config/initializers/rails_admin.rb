RailsAdmin.config do |config|
  # == Configuration options ==
  
  # Require authentication before accessing the admin panel
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  
  # Require admin role to access the admin panel
  config.authorize_with do
    raise "Unauthorized" unless current_user.admin?
  end
  
  # Set the current user for the audit trail
  config.current_user_method(&:current_user)

  # == Cancan ==
  # config.authorize_with :cancan

  # == Pundit ==
  # config.authorize_with :pundit

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  
  config.current_user_method(&:current_user)

  # == Accessible routes ==
  config.main_app_name = ['Home Decor', 'Admin Dashboard']

  # == Dashboard Options ==
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
  
end
