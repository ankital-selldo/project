set -o errexit

bundle install 
bundle exec rails assets:precompile
bundle exec assets:clean
