module Searchable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Elasticsearch::Model

    index_name [Rails.application.engine_name, Rails.env].join("_")
    sake_settings = YAML.load_file(Rails.root.join("config/elasticsearch.yml"))

    settings sake_settings do
      mapping do
        indexes :id, type: "integer"
        indexes :name, analyzer: "ja"
        indexes :kura, analyzer: "ja"
        indexes :bindume_date, type: "date"
        indexes :brew_year, type: "date"
        indexes :todofuken, analyzer: "ja"
        indexes :aroma_impression, analyzer: "ja"
        indexes :color, analyzer: "ja"
        indexes :taste_impression, analyzer: "ja"
        indexes :nigori, analyzer: "ja"
        indexes :awa, analyzer: "ja"
        indexes :tokutei_meisho, analyzer: "ja"
        indexes :genryomai, analyzer: "ja"
        indexes :kakemai, analyzer: "ja"
        indexes :kobo, analyzer: "ja"
        indexes :season, analyzer: "ja"
        indexes :warimizu, analyzer: "ja"
        indexes :moto, analyzer: "ja"
        indexes :roka, analyzer: "ja"
        indexes :shibori, analyzer: "ja"
        indexes :note, analyzer: "ja"
        indexes :bottle_level, analyzer: "ja"
        indexes :hiire, analyzer: "ja"
        indexes :created_at, type: "date"
        indexes :updated_at, type: "date"
      end

      after_save    { Indexer.perform_async(:index,  id) }
      after_destroy { Indexer.perform_async(:delete, id) }
    end

    def as_indexed_json(_options = {})
      hash = as_json(except: %i[taste_value aroma_value nihonshudo sando alcohol aminosando seimai_buai price size])
      hash["tokutei_meisho"] = tokutei_meisho_i18n
      hash["warimizu"] = warimizu == "unknown" ? "" : warimizu_i18n
      hash["moto"] = moto == "unknown" ? "" : moto_i18n
      hash["bottle_level"] = bottle_level_i18n
      hash["hiire"] = hiire == "unknown" ? "" : hiire_i18n
      hash
    end

    # rubocop:disable Metrics/MethodLength
    def self.simple_search(keyword)
      @search_definition = {
        query: { match_all: {} },
        post_filter: { bool: { must: [match_all: {}] } },
        sort: { updated_at: "desc" },
      }

      if keyword.present?
        @search_definition[:query] = {
          multi_match: {
            query: keyword,
            fields: ["*"],
            operator: "and",
          },
        }
      end
      __elasticsearch__.search(@search_definition)
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Metrics/BlockLength
end
