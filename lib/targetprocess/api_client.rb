require 'active_support/inflector'
require 'httparty'
require 'oj'

module Targetprocess
  class APIClient

    def get(path, options={})
      options.merge!(format: 'json')
      options = {body: options}
      response = perform(:get, path, options)
      normalize_data response.parsed_response
    end

    def post(path, attr_hash)
      attr_hash.each { |k,v| attr_hash[k] = json_date(v) if v.is_a?(::Time) }
      content = Oj::dump(convert_dates(attr_hash), :mode => :compat)
      options = {body: content, headers: {'Content-Type' => 'application/json'}}
      response = perform(:post, path, options)
      normalize_data response.parsed_response
    end

    def delete(path)
      perform(:delete, path).response
    end

    private

    def perform(type, path, options={})
      auth = { username: Targetprocess.configuration.username,
               password: Targetprocess.configuration.password }
      options.merge!(basic_auth: auth) 
      check_for_api_errors HTTParty.send(type, generate_url(path), options)
    end

    def check_for_api_errors(response)
      if response['Error']
        error = response['Error']
        status = error['Status'] || response['Status']
        msg = response["Error"]
        if status
          raise "Targetprocess::APIErrors::#{status}".safe_constantize.new(msg) 
        else 
          raise Targetprocess::APIErrors::UnexpectedError.new(msg)
        end
      else
        response
      end
    end

    def generate_url(path)
      if Targetprocess.configuration.api_url[-1] == "/" 
        Targetprocess.configuration.api_url + path  
      else
        Targetprocess.configuration.api_url + "/" + path 
      end
    end

    def normalize_data(hash) 
      hash = Hash[hash.map {|k, v| [k.underscore.to_sym, v] }]
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

    def convert_dates(hash)
      hash.each do |k,v|
        case v
        when ::Time
          hash[k] = "\/Date(#{v.to_i*1000})\/"
        when Hash
          hash[k] = convert_dates(v)
        end
        hash
      end
    end 

  end
end
