  %w{helpers models}.each {|dir| Dir.glob("./app/#{dir}/*.rb", &method(:require))}

  env = Sinatra::Application.settings.environment
  settings = YAML::load(ERB.new(IO.read("config/#{env}.yml")).result)

  {old: [University, UdemyAdmin, Demand, Program, Bailee, Zoom, Zoom2,  ZoomLicenseAvailable, ZoomLicenseRequest],
   new: [UniversityNew, TransferAdmin, TransferUser],
  }.each do |file, classes|
    classes.each do |klass|
      klass.database = settings['database'][file.to_s]["name"]
      value = settings['database'][file.to_s]["tables"][klass.to_s.downcase]
      throw StandardError.new("Data for #{file}.#{klass.to_s.downcase} not specified") unless value
      klass.table_gid = value
    end
  end
