# frozen_string_literal: true

require 'sinatra/respond_with'
require 'sinatra/config_file'
require 'sinatra/required_params'
require 'rollbar/middleware/sinatra'

class MoocApi < Sinatra::Application

  #set :environment, ENV['RACK_ENV']
  use Rollbar::Middleware::Sinatra

  puts Sinatra::Application.settings.environment
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
      config.access_token = settings.rollbar['server_token']
    end
  end

  %w{helpers models}.each {|dir| Dir.glob("./app/#{dir}/*.rb", &method(:require))}

  configure :production, :development do
    [University, Demand, Program, Bailee].each do |klass|
      klass.database = settings.database["name"]
      klass.table_gid = settings.database["tables"][klass.to_s.downcase]
    end
  end

  before "*" do
    if %w[en uk].include? params[:lang]
      session[:lang] = params[:lang]
      params.delete :lang
    end
    session[:lang] ||= 'uk'
  end

  require './app/routes/info_api.rb'

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    response.headers["Access-Control-Allow-Origin"] = settings.url
    200
  end

  not_found do
    status 404
    i18n_erb("404", layout: :main)
  end

  error do
    status 500
    e = env['sinatra.error']
    if settings.show_exceptions
      "Application error\n#{e}\n#{e.backtrace.join("\n")}".gsub(/\n/, '<br />')
    else
      i18n_erb("500", layout: :main)
    end
  end

private

  def i18n_erb(template, options = {})
    if options[:layout]
      options[:layout] = (session[:lang]+'/'+options[:layout].to_s).to_sym
    end
    erb((session[:lang]+'/'+template.to_s).to_sym, options)
  end

end