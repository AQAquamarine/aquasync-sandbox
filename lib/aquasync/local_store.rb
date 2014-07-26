class Aquasync::LocalStore
  attr_accessor :latest_ust, :deviceToken

  class << self
    def instance
      @instance ||= new
    end
  end
end