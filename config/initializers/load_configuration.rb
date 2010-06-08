APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/configuration.yml")[RAILS_ENV]

# application.rb
def authenticate
  if APP_CONFIG['perform_authentication']
    authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG['username'] && password == APP_CONFIG['password']
    end
  end
end

