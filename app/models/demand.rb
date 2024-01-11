class Demand

  class << self
    attr_accessor :table_gid
    attr_accessor :database
  end

  KEYS = [:id, :UA,:EN,:url,:email,:value]

  extend  DelayedSave

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
