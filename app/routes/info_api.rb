class MoocApi < Sinatra::Application

  get '/' do
    @units = University.cached_all
    i18n_erb(:index, layout: :main)
  end

  post '/add' do
    case (params.delete(:type))
      when 'program' then Program.append!(params)
      when 'bailee'  then Bailee.append!(params)
    else
      Demand.append!(params)
    end

    i18n_erb(:greetings, layout: request.xhr? ? nil : :main)
  end

  get '/bailee' do
    @units = University.cached_all
    i18n_erb(:bailee, layout: :main)
  end

  get '/ping' do
    [200, (University.last_updated || 'never').to_s]
  end

  get '/reset' do
    University.reset_cache
    redirect '/'
  end

end