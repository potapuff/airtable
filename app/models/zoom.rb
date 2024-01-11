require './app/models/demand.rb'

class Zoom < Demand
  KEYS = [:id, :value,:email, :options, :name, :tel, :admin, :count, :s, :s, :s, :s, :student_count,:tutor_count]

  extend  DelayedSave

end
