require 'active_support/inflector'
require 'httparty'

module Targetprocess
  class APIClient
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def perform(http, url, content)
      headers = { 'Content-Type' => 'application/json' }
      options = {headers: headers, body: content}

      auth = {username: @config.username,
              password: @config.password }
      default = {:basic_auth => auth}
      default.merge!(:body => {:format => 'json'}) if http == :get
      options.merge!(default) { |k,v1,v2| v1.merge(v2) }
      check_for_api_errors HTTParty.send(http, url, options)
    end

    private

    def check_for_api_errors(response)
      if response['Error']
        error = response['Error']
        status = error['Status'] || response['Status']
        raise ("Targetprocess::#{status}".safe_constantize || Targetprocess::ServerError).new(error['Message'])
      else
        response
      end
    end

  end
end
