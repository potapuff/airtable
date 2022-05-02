class University < Airrecord::Table
  self.table_name = "Requests"

  def self.cached_all
    University.all
  end
end
