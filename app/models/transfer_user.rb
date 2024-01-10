require './app/models/demand.rb'

class TransferUser < Demand
  KEYS = %i(i01 i02
            s03 s04 s05 s06 s07 s08 s08_
            t03 t04 t05 t06 t07 t08 t09 t10 t11 t11_
            p03
            )
  def self.append!(params)
    result = KEYS.map do |key|
      v = params[key]

      v = v.keys if v.respond_to?(:keys)
      v = v.join('; ') if v.is_a?(Array)
      v = v.sanitize
      v
    end
    throw "Bad value" if result.all?{|value|  value.empty? }

    puts result.inspect
    worksheet = auth
    puts worksheet.inspect
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

end
