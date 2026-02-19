# config/puma.rb

# Choose the appropriate configuration based on environment
if ENV["RAILS_ENV"] == "production"
  # Production: Use socket for Nginx
  app_dir = File.expand_path("../..", __FILE__)
  shared_dir = "#{app_dir}/shared"
  
  # Create directories if they don't exist
  Dir.mkdir("#{shared_dir}/tmp") unless File.exist?("#{shared_dir}/tmp")
  Dir.mkdir("#{shared_dir}/tmp/sockets") unless File.exist?("#{shared_dir}/tmp/sockets")
  Dir.mkdir("#{shared_dir}/tmp/pids") unless File.exist?("#{shared_dir}/tmp/pids")
  
  # Socket for Nginx
  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
  
  # PID file
  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  
  # State file
  state_path "#{shared_dir}/tmp/pids/puma.state"
else
  # Development: Use port 3000
  port ENV.fetch("PORT") { 3000 }
end

# Common configuration for all environments
environment ENV.fetch("RAILS_ENV") { "development" }

# Workers and threads
if ENV["RAILS_ENV"] == "production"
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
else
  workers ENV.fetch("WEB_CONCURRENCY") { 0 } # 0 means no clustering in dev
end

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Preload app for workers (only in production)
preload_app! if ENV["RAILS_ENV"] == "production"

# Logging
if ENV["RAILS_ENV"] == "production"
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
end

# On worker boot
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end