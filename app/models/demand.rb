class Demand

  class << self
    attr_accessor :table_gid
    attr_accessor :database
  end


  def self.append!(university, value)
    worksheet = auth

    throw "Bad value" if university.empty? || value.empty?
    worksheet.insert_rows(worksheet.num_rows + 1, [[university, value]])
    worksheet.save
  end

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
