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
      else
        Rails.logger.error "Sitemap refresh command failed"
        raise "Sitemap refresh failed"
      end
      
    rescue => e
      Rails.logger.error "Sitemap refresh failed: #{e.message}"
      raise e
    end
  end
end