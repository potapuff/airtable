require './app/models/demand.rb'

class Zoom < Demand
  KEYS = [:id, :value, :options, :name, :tel, :email]

  def self.append!(params)
    result = KEYS.map { |key| params[key].sanitize }
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
