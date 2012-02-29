Airbrake.configure do |config|
  config.api_key = '76bdad0722032d439cc2553f1928e955'
  config.host = 'errbit.datasektionen.se'
  config.port = 80
  config.secure = config.port == 443
end

