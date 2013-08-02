require 'yaml'
require 'active_support/inflector'

module  Targetprocess
  module EntityCommons
    def self.included(base)
      base.send(:include, InstanceMethods)   
      base.extend(ClassMethods)
    end

    attr_accessor :attributes, :changed

    module ClassMethods 

      def where(params_str, options={})
        options.merge!({:where => params_str})
        self.all(options)
      end

      def all(options={})
        url = self.collection_url
        response = Targetprocess.client.get(url, options)
        response[:items].collect! { |hash| self.new hash }   
      end

      def find(id, options={})
        url = collection_url+"#{id}"
        self.new Targetprocess.client.get(url, options)
      end

      def collection_url
        self.to_s.demodulize.pluralize + "/"
      end

      def meta(option="") 
        url = collection_url + "/meta"
        resp = Targetprocess.client.get(url)
      end
    end

    module InstanceMethods

      def initialize(hash={})
        hash[:id].nil? ? @changed = hash : @attributes = hash
        @changed ||= {}
        @attributes ||= {}
      end
      
      def delete
        url = entity_url
        resp = Targetprocess.client.delete(url)
      end

      def save 
        url = self.class.collection_url
        content = @attributes[:id].nil? ? self.changed : self.changed.merge(id: @attributes[:id])

        resp = Targetprocess.client.post(url, content)
        self.changed = {}
        @attributes.merge!(resp)
      end

      def ==(obj)
          return false unless self.attributes == obj.attributes and self.changed == obj.changed
        true
      end

      def method_missing(name, *args)
        if @changed.has_key?(name) or @attributes.has_key?(name)
          @changed[name] or @attributes[name]
        elsif name.to_s.match("=")
          key = name.to_s.delete("=").to_sym
          @changed[key] = args.first unless @attributes[key] == args.first
        else
          super
        end
      end
      
      def respond_to?(name)
        if name.to_s.match("=") || @attributes.keys.include?(name.to_s)
          true
        else
          super
        end
      end

      def entity_url
        self.class.collection_url + self.attributes[:id].to_s
      end

    end

  end
end
