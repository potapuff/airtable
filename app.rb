# frozen_string_literal: true

require 'sinatra/respond_with'
require 'sinatra/config_file'
require 'sinatra/required_params'
require 'rollbar/middleware/sinatra'

class AlbumsApi < Sinatra::Application

  #set :environment, ENV['RACK_ENV']
  use Rollbar::Middleware::Sinatra

  config_file File.join(File.dirname(__FILE__),
                        'config',
                        "#{Sinatra::Application.settings.environment}.yml")

  set :logging, true
  set :show_exceptions, settings.show_exceptions
  set :run, settings.run
  set :views, Proc.new { File.join(root, "app/views") }

  configure :production, :development do

    #disable :static
    enable :protection
    enable :cross_origin

    Rollbar.configure do |config|
      config.access_token = settings.rollbar
    end
    Airrecord.api_key = settings.airtable_key
  end

  %w{helpers models}.each {|dir| Dir.glob("./app/#{dir}/*.rb", &method(:require))}

  configure :production, :development do
    [Demand, University].each {|clazz| clazz.base_key = settings.airtable_base }
  end

  require './app/routes/info_api.rb'

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    response.headers["Access-Control-Allow-Origin"] = AlbumsApi.settings.url
    200
  end

  before do
    #authenticate!
  end

  error do
    status 500
    e = env['sinatra.error']
    "Application error\n#{e}\n#{e.backtrace.join("\n")}"
  end

  private

end