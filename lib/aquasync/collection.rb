class Aquasync::Collection
  def initialize
    @collection = []
  end

  def sync
    pull_sync
    push_sync
  end

  def pull_sync
    local_store = Aquasync::LocalStore.instance
    latest_ust = local_store.latest_ust
    device_token = local_store.device_token

    deltas = Aquasync::MasterCollection.instance.retrieve_deltas(device_token, latest_ust)
    update_records_by_deltas(deltas)
  end

  def push_sync

  end

  def retrieve_deltas(device_token, latest_ust)
    @collection.select {|r| r.ust > latest_ust }.select {|r| r.device_token != device_token}
  end

  def update_records_by_deltas(deltas)
    deltas.each do |delta|
      record = find(delta.gid)
      if record
        record.resolve_conflict(delta)
      else
        create_record_from_delta(delta)
      end
    end
  end

  def create_record_from_delta(delta)
    @collection.push delta
  end

  def find(gid)
    @collection.select {|r| r.gid == gid}.first
  end

  def dirty_resources
    @collection.select {|r| r.ditry?}
  end

  def size
    @collection.select {|r| not r.deleted?}.size
  end

  alias :count :size

  def method_missing(method, *args, &block)
    @collection.send(method, *args, &block)
  end
end