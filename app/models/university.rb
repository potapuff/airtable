class University < Airrecord::Table
  self.table_name = "Test"

  def to_json
    @fields.to_json
  end

  def self.cached_all
    University.all
  end
end
