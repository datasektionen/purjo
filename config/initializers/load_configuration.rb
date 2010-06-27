filename = Rails.root + "config/configuration.yml"
raise "Missing config/configuration.yml" unless File.exists?(filename)
yaml = YAML.load_file(filename)
if yaml.has_key?(Rails.env)
  Purjo2::Application.settings = ActiveSupport::HashWithIndifferentAccess.new(yaml[Rails.env])
else
  raise "Missing settings for environment #{Rails.env}" unless Rails.env == "test"
end

# application.rb
def authenticate
  if Purjo2::Application.settings['perform_authentication']
    authenticate_or_request_with_http_basic do |username, password|
      username == Purjo2::Application.settings['username'] && password == Purjo2::Application.settings['password']
    end
  end
end

