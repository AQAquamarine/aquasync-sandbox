class Aquasync::Collection
  attr_reader :collection

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

    deltas = master_collection.retrieve_deltas(device_token, latest_ust)
    update_records_by_deltas(deltas)
  end

  def push_sync
    master_collection.receive_deltas dirty_resources
    undirty_resources!
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
    @collection.select {|r| r.dirty?}
  end

  def undirty_resources!
    dirty_resources.each do |resource|
      resource.undirty!
    end
  end

  def size
    @collection.select {|r| not r.deleted?}.size
  end

  alias :count :size

  def method_missing(method, *args, &block)
    @collection.send(method, *args, &block)
  end

  def master_collection
    Aquasync::MasterCollection.instance
  end
end