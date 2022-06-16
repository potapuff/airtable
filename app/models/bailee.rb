require './app/models/demand.rb'

class Bailee < Demand
  KEYS = [:id,  :value, :name,   :bailee,   :bailee_tel, :email]

  def self.append!(params)
    result = KEYS.map { |key| params[key].sanitize }
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
