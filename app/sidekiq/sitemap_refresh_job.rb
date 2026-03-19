# app/sidekiq/sitemap_refresh_job.rb
class SitemapRefreshJob
  include Sidekiq::Job
  
  def perform(*args)
    Rails.logger.info "Starting sitemap refresh at #{Time.current}"
    
    # Generate sitemap without pinging
    system("cd #{Rails.root} && RAILS_ENV=#{Rails.env} bundle exec rake sitemap:refresh:no_ping")
    
    Rails.logger.info "Sitemap refresh completed successfully at #{Time.current}"
    # Remove the ping_search_engines call
  end
end