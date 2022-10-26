class MoocApi < Sinatra::Application

  get '/' do
    redirect '/coursera'
  end

  get '/coursera' do
    @units = University.cached_all[:part]
    @logo_img = 'coursera.svg'
    i18n_erb(:coursera, layout: :main)
  end

  get '/s/coursera/:id' do
    units = University.cached_all[:full]
    json(units[params[:id].to_i] || {})
  end

  get '/f/udemy' do
    @units = University.cached_all[:part]
    @logo_img = 'udemy.svg'
    i18n_erb(:udemy, layout: :main)
  end

  get '/s/udemy/:id' do
    units = UdemyAdmin.cached_all[:full]
    data = units[params[:id].to_i] || {}
    data[:URL] = 'https://ua.udemy.com'
    json(data)
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
    @title = 'Запит додаткової інформації від закладів освіти для розподілу ліцензій Zoom'
    @logo = 'zoom.png'
    @units = University.cached_all[:part]
    erb(:zoom2, layout: :rector_layout)
  end

  get '/zoom3' do
    @title = 'Запит додаткової інформації від закладів освіти для розподілу ліцензій Zoom'
    @logo = 'zoom.png'
    @units = University.cached_all[:part]
    erb(:zoom3, layout: :rector_layout)
  end


  get '/s/udemy/:id' do
    units = UdemyAdmin.cached_all[:full]
    data = units[params[:id].to_i] || {}
    unless data.keys.empty?
      data[:URL] = 'https://ua.udemy.com'
    end
    json(data)
  end

  post '/s/add' do
    puts params.inspect
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
    UdemyAdmin.reset_cache
    redirect '/'
  end


  if MoocApi.settings.cache_ttl.to_i > 0
  Thread.new do
    while true do
      puts 'start University update'
      interval = MoocApi.settings.cache_ttl.to_i
      begin
        University.cached_all(true)
      rescue StandardError => error
        puts 'University update filed'
        Rollbar.error(error)
        interval = [30, MoocApi.settings.cache_ttl.to_i/4].min
      end
      sleep interval
    end
  end
  sleep 3
  Thread.new do
    while true do
      puts 'start UdemyAdmin update'
      interval = MoocApi.settings.cache_ttl.to_i
      begin
        UdemyAdmin.cached_all(true)
      rescue StandardError => error
        puts 'Udemy update failed'
        Rollbar.error(error)
        interval = [30, MoocApi.settings.cache_ttl.to_i/4].min
      end
      sleep interval
    end
  end
  
  else
    puts 'Cache disabled. Set cache_ttl (in seconds) to enable.'
  end

end