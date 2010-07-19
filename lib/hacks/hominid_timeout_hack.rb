module Hominid
  class Base
    def initialize(config = {})
      raise StandardError.new('Please provide your Mailchimp API key.') unless config[:api_key]
      dc = config[:api_key].split('-').last
      defaults = {
        :timeout => nil,
        :double_opt_in => false,
        :merge_tags => {},
        :replace_interests => true,
        :secure => false,
        :send_goodbye => false,
        :send_notify => false,
        :send_welcome => false,
        :update_existing => true
      }
      @config = defaults.merge(config).freeze
      if config[:secure]
        @chimpApi = XMLRPC::Client.new2("https://#{dc}.api.mailchimp.com/#{MAILCHIMP_API_VERSION}/", nil, @config[:timeout])
      else
        @chimpApi = XMLRPC::Client.new2("http://#{dc}.api.mailchimp.com/#{MAILCHIMP_API_VERSION}/", nil, @config[:timeout])
      end
    end
  end
end

