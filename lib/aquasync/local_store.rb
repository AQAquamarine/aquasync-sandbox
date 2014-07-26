class Aquasync::LocalStore
  attr_accessor :latest_ust, :device_token

  class << self
    def instance
      @instance ||= new
    end
  end
end