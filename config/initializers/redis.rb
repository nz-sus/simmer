require 'redis'

# Use the REDIS_URL environment variable if it's set, otherwise default to the Docker service name
redis_url = ENV.fetch('REDIS_URL', 'redis://redis:6379')

$redis = Redis.new(url: redis_url)
