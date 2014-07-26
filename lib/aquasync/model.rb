require 'uuid'

class Aquasync::Model
  attr_accessor :gid, :ust, :device_token, :dirty, :local_timestamp, :deleted_at

  def initialize
    self.gid = (UUID.new).generate
    after_create_or_update
  end

  def update_attribute(key, value)
    self.send("#{key}=", value)
    after_create_or_update
  end

  def update_attributes(attributes)
    attributes.each do |key, value|
      update_attribute key, value
    end
  end

  def destroy
    update_attribute :deleted_at, Time.now
  end

  def deleted?
    !!self.deleted_at
  end

  def after_create_or_update
    dirty!
    set_timestamp
  end

  def set_timestamp
    self.local_timestamp = new_timestamp
  end

  def dirty?
    self.dirty
  end

  def dirty!
    self.dirty = true
  end

  def new_timestamp
    Time.now.getutc.to_i
  end
end