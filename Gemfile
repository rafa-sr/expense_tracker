# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby '2.4.6'
gem 'rack-test',	'0.7.0'
gem 'sinatra',		'2.2.3'
gem 'sequel',           '4.48.0'
gem 'sqlite3'

group :test do
  gem 'rspec',          '3.6.0'
end

group :test, :development do
  gem 'byebug'
  gem 'rubocop'
  gem 'rubocop-gemfile'
  gem 'rubocop-rspec'
end
