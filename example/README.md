#If in doubt, sh README.md ...
gem install bundler rack
bundle install
bundle exec rackup -p 9292 config.ru 
