require "yaml"
require 'active_support/inflector'
require 'httparty'
require 'oj'
require 'targetprocess/request'

  module EntityCommons
    def self.included(base)
      base.send(:include, InstanceMethods)   
      base.extend(ClassMethods)
      base.define_accessors
    end

    ATTR_FILE = File.join(File.dirname(__FILE__), 'attributes.yml')            
    
    module ClassMethods 

      def where(params_str,options={})
        options.merge!({:where => params_str})
        self.all(options)
      end

      def all(options={})
        options = {:body => options} 
        url = self.collection_url
        response = Targetprocess::Request.perform(:get, url, options)
        return_array_of response["Items"]   
      end

      def find(id, options={})
        options = {:body => options} 
        url = self.collection_url+"/#{id}"
        response = Targetprocess::Request.perform(:get, url, options)
        self.new response
      end

      def define_accessors
        self.attributes["readable"].each { |a| attr_reader a }
        self.attributes["writable"].each { |a| attr_writer a } 
      end
      
      def attributes 
        all_attributes = YAML::load_file(ATTR_FILE)
        class_name = self.to_s.demodulize.downcase
        all_attributes[class_name]    
      end 

      def collection_url
        url = Targetprocess.configuration.domain
        url + self.to_s.demodulize.pluralize
      end

      private 

      def return_array_of(response)
        response.is_a?(Hash) ? [self.new(response)] : response.collect! do |item| 
          self.new(item) 
        end 
      end
    end

    module InstanceMethods

      def initialize(hash={})
        hash_to_obj(hash) 
      end
      
      def delete
        url = self.entity_url
        resp = Targetprocess::Request.perform(:delete, url)
      end

      def save 
        url = self.class.collection_url
        header = { 'Content-Type' => 'application/json' }
        content = Oj::dump(self.to_hash, :mode => :compat)
        resp = Targetprocess::Request.perform(:post, url, {body: content ,headers: header})
        saved = self.class.new resp
        self.class.attributes["readable"].each do |at|
          self.instance_variable_set("@#{at}", saved.send(at))
        end
        self
      end

      def ==(obj)
        self.class.attributes["readable"].each  do |var| 
          return false unless self.send(var) == obj.send(var) 
        end
        true
      end

      def entity_url
        self.class.collection_url + "/#{self.id}"
      end
      
      def to_hash
        hash = {}
        self.class.attributes["writable"].each do |k|
          value = self.send(k)
          value = json_date(value) if !value.nil? && k.match(/date/)
          hash.merge!(k.to_sym => value) unless value.nil?
        end
        hash
      end
      
      private

      def json_date(time)
        "\/Date(#{time.to_i}000+0#{time.utc_offset/3600}00)\/"
      end

      def hash_to_obj(hash) 
        hash.each do |k,v|
          case v 
          when Hash
            v = Hash[v.map {|nk, nv| [nk.downcase.to_sym, nv] }]
          when /Date\((\d+)-(\d+)\)/
            v = Time.at($1.to_i/1000)
          end
          self.instance_variable_set("@#{k.downcase}", v)
        end
      end
    end

  end
