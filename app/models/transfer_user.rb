require './app/models/demand.rb'

class TransferUser < Demand
  KEYS = %i(i01 i02 i03 i04 i05
            i06 i07 i08 i09 i10
            i11 i12
            )
  def self.append!(params)
    result = KEYS.map do |key|
      v = params[key].sanitize
      v = v.join('; ') if v.is_a?(Array)
      v
    end
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
