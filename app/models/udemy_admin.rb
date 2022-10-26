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

  def self.cached_all(force = false)
    return all unless MoocApi.settings.cache_ttl.to_i > 0
    
    stamp = Time.now
    if @@holder.nil? || force
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
