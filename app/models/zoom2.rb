require './app/models/demand.rb'

class Zoom2 < Demand
  KEYS = [:id, :value,:email, :options, :name, :tel, :admin, :tutor_count, :student_count]

  extend  DelayedSave

end
