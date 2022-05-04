class MoocApi < Sinatra::Application

  get '/' do
    @unis = University.cached_all
    erb(:index, layout: :main)
  end

  post '/add' do
    Demand.append!(params[:university].sanitize, params[:value].sanitize)
    erb(:greetings, layout: :main)
  end


  get '/ping' do
    [200, University.last_update || 'never']
  end

end