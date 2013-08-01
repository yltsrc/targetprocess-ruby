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
        p response
        response[:items].collect! { |hash| self.new hash }   
      end

      def find(id, options={})
        url = collection_url+"#{id}"
        self.new Targetprocess.client.get(url, options)
      end

      def collection_url
        self.to_s.demodulize.pluralize + "/"
      end

      def meta(option) 
        url = collection_url + "/meta"
        resp = Targetprocess::HTTPRequest.perform(:get, url)
        hash={}
        case option
        when :actions
          [:cancreate, :canupdatem, :candelete].each do |key|
            hash.merge!({key =>resp[key]})
          end
        when :values
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcevaluesdescription][:items]
        when :references
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcereferencesdescription][:items]
        when :collections
          hash = resp[:resourcemetadatapropertiesdescription][:resourcemetadatapropertiesresourcecollectionsdescription][:items]
        else
          resp
        end
        hash
      end
    end

    module InstanceMethods

      def initialize(hash={})
        @attributes = hash
      end
      
      def delete
        url = self.entity_url
        resp = Targetprocess.client.delete(url)
      end

      def save 
        url = self.class.collection_url
        resp = Targetprocess.client.post(url, content)
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

      def method_missing(name, *args)
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

      private

      def entity_url
        self.class.collection_url + self.id.to_s
      end

    end

  end
end
