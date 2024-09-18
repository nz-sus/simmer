module Searchable
  extend ActiveSupport::Concern

  included do |base|
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # Define the Elasticsearch index settings and mappings
    settings do
      mappings dynamic: 'false' do
        base::elasticsearch_mappings.each do |field, options|
          indexes field, options
        end
      end
    end
    def as_indexed_json(options = {})
      self.as_json(only: self.class.elasticsearch_mappings.keys)
    end
  end

  class_methods do
    def search(args = {})
      query = args[:q]      
      query_type = args[:q_type]&.to_sym||:multi_match
      filters = args[:filters] || {}      
      case query_type
      when :multi_match
        params = {
          query: {
            multi_match: {
              query: query,
              fields: self::SEARCHABLE_FIELDS,
              fuzziness: "AUTO"
            }
          }
        }
      when :match
        params = {
          query: {
            match: {
              message: {
                query: query,
                fuzziness: "AUTO"
              }
            }
          }
        }
      when :query_string
        params = {
          query: {
            query_string: {
              query: "*#{query}*",
              fields: self::SEARCHABLE_FIELDS
            }
          }
        }
      when :wildcard
        params = {
          query: {
            wildcard: {
              message: {
                value: "*#{query}*"
              }
            }
          }
        }
      else
        raise ArgumentError, "Unsupported query type: #{query_type}"
      end
      
      self.__elasticsearch__.search(params).records.to_a
    end
  end
end
