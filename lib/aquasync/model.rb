require 'uuid'

class Aquasync::Model
  attr_accessor :gid, :ust, :device_token, :dirty, :local_timestamp, :deleted_at

  def initialize
    self.gid = (UUID.new).generate
    self.local_timestamp = Time.now.getutc.to_i
  end
end