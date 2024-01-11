class UdemyAdmin

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    i = 0
    data_full, data_part = [], []
    auth.rows.each do |row|
      next if (i+=1) == 1
      data_full <<  {
        id:    (row[0].to_i rescue -1),
        admin: row[1].filtrate.my_split(/[,;]/)
      }
    end
    {full: data_full.index_by{|x| x[:id]}}
  end

  extend CachedModel

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
