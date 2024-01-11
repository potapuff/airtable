class Demand

  class << self
    attr_accessor :table_gid
    attr_accessor :database
  end

  KEYS = [:id, :UA,:EN,:url,:email,:value]

  def self.append!(params)
    puts 'Original!'
    result = KEYS.map { |key| params[key].sanitize }
    throw "Bad value" if result.all?{|value|  value.empty? }

    worksheet = auth
    worksheet.insert_rows(worksheet.num_rows + 1, [result])
    worksheet.save
  end

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
