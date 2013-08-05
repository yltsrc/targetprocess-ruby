require 'yaml'
require 'active_support/inflector'
require 'active_support/concern'

module  Targetprocess
  module EntityCommons
    extend ActiveSupport::Concern
    
    attr_accessor :attributes, :changed_attributes

    def initialize(hash={})
      hash[:id].nil? ? @changed_attributes = hash : @attributes = hash
      @changed_attributes ||= {}
      @attributes ||= {}
    end
    
    def delete
      path = entity_path
      resp = Targetprocess.client.delete(path)
      true if resp.code == "200"
    end

    def save 
      path = self.class.collection_path
      content = if @attributes[:id].nil? 
        self.changed_attributes 
      else 
        self.changed_attributes.merge(id: @attributes[:id])
      end
      resp = Targetprocess.client.post(path, content)
      self.changed_attributes = {}
      @attributes.merge!(resp)
    end

    def ==(obj)
        self_keys = self.attributes.keys | self.changed_attributes.keys
        obj_keys = obj.attributes.keys | obj.changed_attributes.keys
        return false unless (self_keys <=> obj_keys) == 0
        self_keys.each do |key|
          return false unless self.send(key) == obj.send(key)
        end
      true
    end

    def method_missing(name, *args)
      if @changed_attributes.has_key?(name) or @attributes.has_key?(name)
        @changed_attributes[name] || @attributes[name]
      elsif name.to_s.match(/=\z/)
        key = name.to_s.delete("=").to_sym
        @changed_attributes[key] = args.first unless @attributes[key] == args.first
      else
        super
      end
    end
    
    def respond_to?(name)
      if name.to_s.match(/=\z/) || @attributes.keys.include?(name.to_s)
        true
      else
        super
      end
    end

    def entity_path
      self.class.collection_path + self.attributes[:id].to_s
    end

    module ClassMethods 
      def where(params_str, options={})
        options.merge!({:where => params_str})
        self.all(options)
      end

      def all(options={})
        path = self.collection_path
        response = Targetprocess.client.get(path, options)
        response[:items].collect! { |hash| self.new hash }   
      end

      def find(id, options={})
        path = collection_path+"#{id}"
        self.new Targetprocess.client.get(path, options)
      end

      def collection_path
        self.to_s.demodulize.pluralize + "/"
      end

      def meta 
        path = collection_path + "/meta"
        resp = Targetprocess.client.get(path)
      end
    end

  end
end
