class AlbumsApi < Sinatra::Application

  get '/' do
    @unis = University.cached_all
    erb(:index, layout: :main)
    #    respond_to do |format|
    #       format.json { MultiJson.dump(album.to_api(true, current_user)) }
    #       format.html { redirect full_path(album.identifier) }
    #     end
  end

  post '/add' do
    @demand = {role:'unknown', platform: Sanitize.fragment(params[:university])}
    Demand.new(@demand).save
    erb(:greetings, layout: :main)
  end


  get '/ping' do
    [200, "Супер!"]
  end

end