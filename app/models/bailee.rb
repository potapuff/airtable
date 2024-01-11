require './app/models/demand.rb'

class Bailee < Demand
  KEYS = [:id,  :value, :name,   :bailee,   :bailee_tel, :email]

  extend  DelayedSave

end
