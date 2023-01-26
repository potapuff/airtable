class MoocApi < Sinatra::Application

  get '/' do
    redirect '/coursera'
  end

  get '/coursera' do
    @page_title = 'Coursera for Ukraine'
    @units = University.cached_all()[:part]
    @logo_img = 'coursera.svg'
    i18n_erb(:coursera, layout: :main)
  end

  get '/s/coursera/:id' do
    units = University.cached_all()[:full]
    json(units[params[:id].to_i] || {})
  end

  get '/f/udemy' do
    @page_title = 'Udemy for Ukraine'
    @units = University.cached_all()[:part]
    @logo_img = 'udemy.svg'
    i18n_erb(:udemy, layout: :main)
  end

  get '/s/udemy/:id' do
    units = UdemyAdmin.cached_all()[:full]
    data = units[params[:id].to_i] || {}
    data[:URL] = 'https://ua.udemy.com'
    json(data)
  end

  get '/rector' do
    @title = 'Шановні керівники закладів фахової передвищої та вищої освіти!'
    @logo = 'logo.svg'
    @units = University.cached_all()[:part]
    erb(:rector, layout: :rector_layout)
  end

  get '/zoom' do
    @page_title = 'zoom'
    @title = 'Шановні керівники закладів освіти!'
    @logo = 'zoom.png'
    @units = University.cached_all()[:part]
    erb(:zoom, layout: :rector_layout)
  end

  get '/zoom2' do
    @page_title = 'Zoom - 2'
    @title = 'Запит додаткової інформації від закладів освіти для розподілу ліцензій Zoom'
    @logo = 'zoom.png'
    @units = University.cached_all()[:part]
    erb(:zoom2, layout: :rector_layout)
  end

  get '/zoom3' do
    @page_title = 'Zoom - 3'
    @title = 'Запит додаткової інформації від закладів освіти для розподілу ліцензій Zoom'
    @logo = 'zoom.png'
    @units = University.cached_all()[:part]
    erb(:zoom3, layout: :rector_layout)
  end

  get '/s/zoom-license' do
    @page_title = 'Zoom, запит ліцензій'
    @title = 'Запит на отримання ліцензій Zoom'
    @logo = 'zoom.png'
    @units = University.cached_all()[:part]
    erb(:zoomlicense, layout: :rector_layout)
  end

  get '/s/zoom-license/:id' do
    units = ZoomLicenseAvailable.cached_all()[:data]
    data = units.detect{|x| x[:id] == params[:id].to_i}
    return json({status: '404'}) unless data
    json({domain: data[:domain], status: data[:used]<data[:total] ? 'yes' : 'no'})
  end


  get '/s/udemy/:id' do
    units = UdemyAdmin.cached_all()[:full]
    data = units[params[:id].to_i] || {}
    unless data.keys.empty?
      data[:URL] = 'https://ua.udemy.com'
    end
    json(data)
  end

  post '/s/add' do
    puts params.inspect
    result = case (params.delete(:type))
             when 'program' then Program.append!(params)
             when 'bailee' then Bailee.append!(params)
             when 'zoom' then Zoom.append!(params)
             when 'zoom2' then Zoom2.append!(params)
             when 'zoom-license' then ZoomLicenseRequest.append!(params)
             else
               Demand.append!(params)
             end
    puts result
    i18n_erb(:greetings, layout: request.xhr? ? nil : :main)
  end

  get '/s/ping' do
    [200, (University.last_updated || 'never').to_s]
  end

  CACHED = [University, UdemyAdmin, ZoomLicenseAvailable]

  get '/s/reset' do
    CACHED.each do |klazz|
      klazz.reset_cache
    end
    redirect '/'
  end

  if MoocApi.settings.cache_ttl.to_i > 0
    CACHED.each do |klazz|
      Thread.new do
        while true do
          interval = MoocApi.settings.cache_ttl.to_i
          begin
            klazz.cached_all(true)
          rescue StandardError => error
            puts "#{klazz} update filed"
            Rollbar.error(error)
            interval = [60, MoocApi.settings.cache_ttl.to_i / 3].min
          end
          sleep interval
        end
      end
      sleep 3
    end
  else
    puts 'Cache disabled. Set cache_ttl (in seconds) to enable.'
  end

end