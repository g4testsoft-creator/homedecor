# app/sidekiq/sitemap_refresh_job.rb
class SitemapRefreshJob
  include Sidekiq::Job
  sidekiq_options queue: 'default', retry: 3, backtrace: true

  def perform(*args)
    Rails.logger.info "Starting sitemap refresh at #{Time.current}"
    
    begin
      # Execute the rake command as a system call
      rails_env = Rails.env
      result = system("cd #{Rails.root} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh")
      
      if result
        Rails.logger.info "Sitemap refresh completed successfully at #{Time.current}"
        ping_search_engines if Rails.env.production?
      else
        Rails.logger.error "Sitemap refresh command failed"
        raise "Sitemap refresh failed"
      end
      
    rescue => e
      Rails.logger.error "Sitemap refresh failed: #{e.message}"
      raise e
    end
  end
  
  private
  
  def ping_search_engines
    sitemap_url = "#{Rails.application.routes.default_url_options[:host]}/sitemap.xml"
    
    # Ping Google
    Net::HTTP.get(URI.parse("https://www.google.com/ping?sitemap=#{CGI.escape(sitemap_url)}"))
    
    # Ping Bing
    Net::HTTP.get(URI.parse("https://www.bing.com/ping?sitemap=#{CGI.escape(sitemap_url)}"))
  rescue => e
    Rails.logger.warn "Failed to ping search engines: #{e.message}"
  end
end