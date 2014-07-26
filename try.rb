require_relative 'lib/aquasync'
require_relative 'models/book'

# Scenario 1: Local <=> Remote synchronization

local_collection = Aquasync::Collection.new
book = Book.new
puts book.gid
puts book.local_timestamp
puts book.dirty?