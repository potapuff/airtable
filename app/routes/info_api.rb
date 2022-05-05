class MoocApi < Sinatra::Application

  get '/' do
    @unis = University.cached_all
    i18n_erb(:index, layout: :main)
  end

  post '/add' do
    (params.delete(:type) == 'program' ) ?  Program.append!(params) : Demand.append!(params)
    i18n_erb(:greetings, layout: :main)
  end

  get '/ping' do
    [200, University.last_updated || 'never']
  end

  get '/reset' do
    University.reset_cache
    redirect '/'
  end

end