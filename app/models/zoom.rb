require './app/models/demand.rb'

class Zoom < Demand
  KEYS = [:id, :value,:email, :options, :name, :tel, :admin, :count, :s, :s, :s, :s, :student_count,:tutor_count]

  def self.append!(params)
    result = KEYS.map { |key| params[key].sanitize }
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
