source 'https://rubygems.org'
gemspec name: 'flipper'

Dir['flipper-*.gemspec'].each do |gemspec|
  plugin = gemspec.scan(/flipper-(.*)\.gemspec/).flatten.first
  gemspec(name: "flipper-#{plugin}", development_group: plugin)
end

gem 'debug'
gem 'rake'
gem 'statsd-ruby', '~> 1.2.1'
gem 'rspec', '~> 3.0'
gem 'rack-test'
gem 'rackup'
gem 'sqlite3', "~> #{ENV['SQLITE3_VERSION'] || '1.4.1'}"
gem 'rails', "~> #{ENV['RAILS_VERSION'] || '7.0.4'}"
gem 'minitest', '~> 5.18'
gem 'minitest-documentation'
gem 'webmock'
gem 'ice_age'
gem 'redis-namespace'
gem 'webrick'
gem 'stackprof'
gem 'benchmark-ips'
gem 'stackprof-webnav'
gem 'flamegraph'
gem 'climate_control'
gem 'mysql2'
gem 'pg'

group(:guard) do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'rb-fsevent'
end
