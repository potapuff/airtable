class MoocApi < Sinatra::Application

  get '/' do
    @unis = University.cached_all
    i18n_erb(:index, layout: :main)
  end

  post '/add' do
    Demand.append!(params)
    i18n_erb(:greetings, layout: :main)
  end

  get '/ping' do
    [200, University.last_update || 'never']
  end

end