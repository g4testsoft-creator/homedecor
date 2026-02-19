# /home/ubuntu/homedecor/config/puma.rb
# Use a socket file for Nginx
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Create directories if they don't exist
Dir.mkdir("#{shared_dir}/tmp") unless File.exist?("#{shared_dir}/tmp")
Dir.mkdir("#{shared_dir}/tmp/sockets") unless File.exist?("#{shared_dir}/tmp/sockets")
Dir.mkdir("#{shared_dir}/tmp/pids") unless File.exist?("#{shared_dir}/tmp/pids")

# Socket for Nginx
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Also bind to port for direct access (optional)
# port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# Workers and threads
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Preload app for workers
preload_app!

# PID file
pidfile "#{shared_dir}/tmp/pids/puma.pid"

# State file
state_path "#{shared_dir}/tmp/pids/puma.state"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# On worker boot
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
