class Aquasync::Collection
  def initialize
    @collection = []
  end

  def push(resource)
    @collection.push resource
  end
end