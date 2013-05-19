require 'active_support/concern' 
require 'covercache/model/cacher'

module Covercache
  module Model
    extend ActiveSupport::Concern

    included do
      extend  Cacher          # Include and Extend so cache method is available in all contexts
      include Cacher
    end

    module ClassMethods
      def generate_model_digest
        return unless covercache_model_source?
        file = File.read self.covercache_model_source
        Digest::MD5.hexdigest(file)
      rescue
        nil
      end
    
      # Generates and sets file_digest attribute
      def generate_model_digest!
        self.covercache_model_digest = self.generate_model_digest
      end
      
      def covercache_flush!
        self.covercache_keys.each do |key|
          Rails.cache.delete(key) # if Rails.cache.exist?(key)
        end.clear
        self.covercache_keys.empty?
      end
    end
    
    # flush cache on after_commit callback
    def covercache_flush_cache!
      self.class.send :covercache_flush!
    end
  end
end