class University

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    data = []
    i = 0
    auth.rows.each do |row|
      next if (i+=1) == 1
      data << {
        :id => row[0],
        :domain => row[2],
        :UA => row[3],
        :EN => row[4],
        :URL => row[5],
        :admin => !row[6].empty?
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
    @@holder && @@holder[:stamp]
  end

  def self.reset_cache
    @@holder = nil
  end


  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
