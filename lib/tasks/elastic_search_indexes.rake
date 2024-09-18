namespace :elasticsearch do
  desc "Add ElasticSearch indexes for GitleaksResults"

  task setup: :environment do
    add_indexes
    import_data
  end

  # This task creates the index in Elasticsearch. It must be run once per indexed model before any data can be added.
  task add_indexes: :environment do
    GitleaksResult.__elasticsearch__.create_index!
  end

  # Records are added automatically when they are created or updated, but if you need to reindex all records, you can run the following task:
  task import_data: :environment do
    GitleaksResult.import
  end
end
