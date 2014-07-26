class Aquasync::MasterCollection
  attr_reader :collection

  class << self
    def instance
      @instance ||= Aquasync::MasterCollection.new
    end
  end

  def drop_all
    @collection = Aquasync::Collection.new
  end

  def initialize
    @collection = Aquasync::Collection.new
  end

  def receive_deltas(deltas)
    deltas.each do |delta|
      record = @collection.find(delta.gid)
      if record
        record.resolve_conflict(delta)
      else
        @collection.create_record_from_delta(delta)
      end
    end
  end

  def retrieve_deltas(device_token, latest_ust)
    @collection.select {|r| r.ust > latest_ust }.select {|r| r.device_token != device_token}
  end
end