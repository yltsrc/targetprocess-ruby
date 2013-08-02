require 'active_support/inflector'
require 'httparty'
require 'oj'

module Targetprocess
  class APIClient
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def get(url, options={})
      options.merge!(format: 'json')
      options = {body: options}
      response = perform(:get, @config.domain+url, options)
      normalize_data response.parsed_response
    end

    def post(url, attr_hash)
      attr_hash.each { |k,v| attr_hash[k] = json_date(v) if v.is_a?(Date) }
      content = Oj::dump(attr_hash, :mode => :compat)
      options = {body: content, headers: {'Content-Type' => 'application/json'}}
      response = perform(:post, @config.domain+url, options)
      normalize_data response.parsed_response
    end

    def delete(url)
      perform(:delete, @config.domain+url).response.code
    end

    private

    def perform(type, url, options={})
      auth = { username: @config.username,
               password: @config.password }
      options.merge!(basic_auth: auth)  
      check_for_api_errors HTTParty.send(type, url, options)
    end

    def check_for_api_errors(response)
      if response['Error']
        error = response['Error']
        status = error['Status'] || response['Status']
        msg = error['Message'] || response["Message"]
        raise ("Targetprocess::#{status}".safe_constantize || Targetprocess::ServerError).new(msg)
      else
        response
      end
    end

    def normalize_data(hash) 
      hash = Hash[hash.map {|k, v| [k.downcase.to_sym, v] }]
      hash.each do |k,v|
        hash[k] = case v 
        when Hash
          normalize_data(v)
        when Array
          v.collect! { |el| normalize_data(el) }
        when /Date\((\d+)-(\d+)\)/
          ::Time.at($1.to_i/1000)
        else
          v
        end
      end
    end

    def json_date(time)
      "\/Date(#{time.to_i}000+0#{time.utc_offset/3600}00)\/"
    end

  end
end
