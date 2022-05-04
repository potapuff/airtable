class University

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    data = []
    auth.rows.each do |row|
      data << {
        :text => row[3],
        :EN => row[4],
        :URL => row[5],
      }
    end
    data
  end

  def self.cached_all
    stamp = Time.now
    if @@holder.nil? || (@@holder[:stamp] < stamp - 5*60)
      @@holder = {
        stamp: stamp,
        data: all
      }
    end
    @@holder[:data]
  end

  def self.last_updated
    @@holder.nil && @@holder[:stamp]
  end

private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
