#!/usr/bin/ruby

require 'sinatra'
require 'sinatra/partial'
require './blogs.rb'
require 'erb'


module Sinatra
  class App < Sinatra::Base
  helpers Sinatra::Blogs

  register Sinatra::Partial
  set :partial_template_engine, :erb
  set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 30]


    #serve the blogs
    ['/?', '/index.html'].each do |path|
      get path do
        if params['start'].nil?
          params['start']=0
        end
        if params['fin'].nil?
          params['fin']=4
        end
        erb :blogs, :locals => {:blogs => get_blogs, :start => params['start'], :finish => params['fin'] }
      end
    end

    #Serve the Blog 
    get '/blog/:year/:month/:day/:title' do
      erb :blog, :locals => {:blog => get_blog(params['year']+"-"+params['month']+"-"+params['day']+"_"+params['title']+".yml") }
    end

  end
end
