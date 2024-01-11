require './app/models/demand.rb'

class ZoomLicenseRequest < Demand
  KEYS = [:email, :fname, :sname, :url, :blank1, :blank2, :link]

  extend  DelayedSave

end
