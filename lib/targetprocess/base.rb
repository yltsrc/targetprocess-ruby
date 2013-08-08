require 'yaml'
require 'active_support/inflector'

module  Targetprocess
  module Base
    
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    attr_reader :attributes, :changed_attributes

    module InstanceMethods
      def initialize(hash={})
        @changed_attributes = hash
        @attributes = {}
      end
      
      def delete
        path = entity_path
        resp = Targetprocess.client.delete(path)
        true if resp.code == "200"
      end

      def save 
        path = self.class.collection_path
        @changed_attributes.merge!(id: @attributes[:id]) if @attributes[:id]
        resp = Targetprocess.client.post(path, @changed_attributes)
        @changed_attributes = {}
        @attributes.merge!(resp)
        self
      end

      def ==(obj)
        return false unless self.class == obj.class
        self_keys = @attributes.keys | @changed_attributes.keys
        obj_keys = obj.attributes.keys | obj.changed_attributes.keys
        return (self_keys|obj_keys).all? {|key| self.send(key) == obj.send(key)}
      end

      def method_missing(name, *args)
        if name.to_s.match(/=\z/) 
          key = name.to_s.delete("=").to_sym unless name.to_s.match(/\bid\b/)
          if @attributes[key] == args.first
            @changed_attributes.delete(key)
          else
            @changed_attributes[key] = args.first
          end
        else
          @changed_attributes[name] or @attributes[name] 
        end
      end
      
      def respond_to?(name)
        if name.to_s.match(/=\z/) || @attributes.keys.include?(name.to_s) || @changed_attributes.include?(name.to_s)
          true
        else
          super
        end
      end

      def entity_path
        self.class.collection_path + @attributes[:id].to_s
      end
    end

    module ClassMethods 
      def where(params_str, options={})
        options.merge!({:where => params_str})
        self.all(options)
      end

      def all(options={})
        path = self.collection_path
        response = Targetprocess.client.get(path, options)
        response[:items].collect! do |hash| 
          result = self.new 
          result.attributes.merge!(hash)
          result
        end
      end

      def find(id, options={})
        path = collection_path + "#{id}"
        result = self.new  
        result.attributes.merge!(Targetprocess.client.get(path, options))
        result
      end

      def collection_path
        self.to_s.demodulize.pluralize + "/"
      end

      def meta 
        Targetprocess.client.get(collection_path + "/meta")
      end
    end
  end
end
