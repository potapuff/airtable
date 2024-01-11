class UniversityNew

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    i = 0
    data_part = []
    auth.rows.each do |row|
      next if (i+=1) == 1
      a =  {
        :id => row[0].to_i,
        :UA => row[2],
      }
      data_part << a
    end
    {part: data_part}
  end

  extend CachedModel

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
