require 'yaml'
require 'active_support/inflector'

module  Targetprocess
  module EntityCommons
    def self.included(base)
      base.send(:include, InstanceMethods)   
      base.extend(ClassMethods)
    end

    ATTR_FILE = File.join(File.dirname(__FILE__), 'attributes.yml')            
    
    attr_accessor :attributes

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
        hash={}
        case option
        when :actions
          [:cancreate, :canupdate, :candelete].each do |key|
            hash.merge!({key =>resp[key]})
          end
        when :values
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcevaluesdescription][:items]
        when :references
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcereferencesdescription][:items]
        when :collections
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcecollectionsdescription][:items]
        else
          hash = resp
        end
        hash
      end
    end

    module InstanceMethods

      def initialize(hash={})
        @attributes = hash
      end
      
      def delete
        url = entity_url
        resp = Targetprocess.client.delete(url)
      end

      def save 
        url = self.class.collection_url
        resp = Targetprocess.client.post(url, self.attributes)
        self.attributes.merge!(resp)
      end

      def ==(obj)
        self.attributes.each  do |k,v| 
          return false unless v == obj.attributes(k) 
        end
        true
      end

      def method_missing(name, *args)
        p name
        if @attributes.keys.include?(name)
          @attributes[name] 
        elsif name.to_s.match("=")
          @attributes[name.to_s.delete("=").to_sym] = args.first
        else
          raise NoMethodError
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
