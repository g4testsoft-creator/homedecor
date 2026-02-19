# config/puma.rb
# Use workers for better WebSocket performance
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

on_worker_boot do
  # Worker specific setup for Rails
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Allow puma to handle WebSockets
plugin :tmp_restart