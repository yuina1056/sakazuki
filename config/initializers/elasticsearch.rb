config = {
  host: ENV["ELASTICSEARCH_HOST"] || "localhost",
  port: ENV["ELASTICSEARCH_PORT"] || "9200",
  user: ENV["ELASTICSEARCH_USER"] || "",
  password: ENV["ELASTICSEARCH_PASSWORD"] || "",
}
Elasticsearch::Model.client = Elasticsearch::Client.new(config)

# Print Curl-formatted traces in development into a file
if Rails.env.development?
  tracer = ActiveSupport::Logger.new("log/elasticsearch.log")
  tracer.level = Logger::DEBUG
  Elasticsearch::Model.client.transport.tracer = tracer
end
