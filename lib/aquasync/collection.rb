class Aquasync::Collection
  def initialize
    @collection = []
  end

  def sync
    pull_sync
    push_sync
  end

  def pull_sync

  end

  def push_sync

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