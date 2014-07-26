class Aquasync::MasterCollection
  class << self
    def instance
      @collection ||= Aquasync::Collection.new
    end
  end
end