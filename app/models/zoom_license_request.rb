require './app/models/demand.rb'

class ZoomLicenseRequest < Demand
  KEYS = [:email, :fname, :sname, :url, :blank1, :blank2, :link]

  def self.append!(params)
    result = KEYS.map { |key| params[key].sanitize.to_s[0..250] }
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
