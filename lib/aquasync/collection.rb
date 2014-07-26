class Aquasync::Collection
  def initialize
    @collection = []
  end

  def size
    @collection.select {|r| not r.deleted?}.size
  end

  alias :count :size

  def method_missing(method, *args, &block)
    @collection.send(method, *args, &block)
  end
end