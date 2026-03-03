RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic('Admin Area') do |username, password|
      username == 'admin' && password == 'password'
    end
  end
  
  config.current_user_method { nil }
  
  config.main_app_name = ['Home Decor', 'Admin Dashboard']

  config.included_models = ['User', 'DecorItem', 'Category', 'Review', 'Product']

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