class ZoomLicenseAvailable

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    i = 0
    data = []
    auth.rows.each do |row|
      next if (i+=1) < 12
      data <<
        {
        :id => row[0].to_i,
        :domain => row[2].filtrate.my_split(/[,;]/),
        :total => (row[5].to_i rescue 0),
        :used => (row[6].to_i rescue 0)
        }
    end
    {data: data}
  end

  extend CachedModel

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
