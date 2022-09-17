class MoocApi < Sinatra::Application

  get '/' do
    redirect '/coursera'
  end

  get '/coursera' do
    @units = University.cached_all[:part]
    i18n_erb(:index, layout: :main)
  end

  get '/rector' do
    @title = 'Шановні керівники закладів фахової передвищої та вищої освіти!'
    @logo = 'logo.svg'
    @units = University.cached_all[:part]
    erb(:rector, layout: :rector_layout)
  end

  get '/zoom' do
    @title = 'Шановні керівники закладів освіти!'
    @logo = 'zoom.png'
    @units = University.cached_all[:part]
    erb(:zoom, layout: :rector_layout)
  end

  get '/zoom2' do
    @title = 'Шановні керівники закладів освіти!'
    @logo = 'zoom.png'
    @units = University.cached_all[:part]
    erb(:zoom, layout: :rector_layout)
  end

  get '/zoom3' do
    @title = 'Шановні керівники закладів освіти!'
    @logo = 'zoom.png'
    @units = University.cached_all[:part]
    erb(:zoom, layout: :rector_layout)
  end

  get '/s/:lang/:id' do
    units = University.cached_all[:full]
    json(units[params[:id].to_i] || {})
  end

  post '/s/add' do
    case (params.delete(:type))
      when 'program' then Program.append!(params)
      when 'bailee'  then Bailee.append!(params)
      when 'zoom'    then Zoom.append!(params)
    else
      Demand.append!(params)
    end

    i18n_erb(:greetings, layout: request.xhr? ? nil : :main)
  end

  get '/s/ping' do
    [200, (University.last_updated || 'never').to_s]
  end

  get '/s/reset' do
    University.reset_cache
    redirect '/'
  end


  if MoocApi.settings.cache_ttl.to_i > 0
  Thread.new do
    while true do
      University.cached_all(true)
      sleep MoocApi.settings.cache_ttl.to_i*3/4
    end
  end
  else
    puts 'Cache disabled. Set cache_ttl (in seconds) to enable.'
  end

end