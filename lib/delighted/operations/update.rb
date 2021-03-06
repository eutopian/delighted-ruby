module Delighted
  module Operations
    module Update
      def self.included(klass)
        unless klass.singleton_resource?
          klass.extend(Pluralton::ClassMethods)
        end
      end

      def save(client = Delighted.shared_client)
        params = Utils.hash_without_key(to_hash, :id)
        params = params.merge(:expand => expanded_attribute_names) unless expanded_attribute_names.empty?
        params = Utils.serialize_values(params)
        json = client.put_json(self.class.path(id), params)
        self.class.new(json)
      end

      module Pluralton
        module ClassMethods
          def path(id = nil)
            id ? "#{@path}/#{id}" : @path
          end
        end
      end
    end
  end
end
