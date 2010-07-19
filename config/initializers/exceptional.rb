if Exceptional::Config.api_key.nil?
  begin
    Exceptional::Config.load(File.join(RAILS_ROOT, "/config/exceptional.yml"))
    ::Rails.configuration.middleware.insert_after 'ActionDispatch::ShowExceptions', Rack::RailsExceptional
  rescue => e
    STDERR.puts "Problem starting Exceptional Plugin. Your app will run as normal."
    Exceptional.logger.error(e.message)
    Exceptional.logger.error(e.backtrace)
  end
end