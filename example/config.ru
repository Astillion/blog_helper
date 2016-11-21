#!/usr/bin/ruby

require 'rubygems'
require 'bundler'
require 'sinatra/base'
Bundler.require

require './app'

use Rack::ShowExceptions
use Rack::Lint

map '/' do
  run Sinatra::App.new
end
