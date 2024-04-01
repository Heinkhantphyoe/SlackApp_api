#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# 起動時にマイグレーションを実行する
# bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"