class Aquasync::Collection
  def initialize
    @collection = []
  end


  def method_missing(method, *args, &block)
    @collection.send(method, *args, &block)
  end
end