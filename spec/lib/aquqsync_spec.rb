require_relative '../../spec/spec_helper'

describe "Aquasync" do
  context "Book#new" do
    let(:book) { Book.new }
    it { expect(book.gid).not_to eq nil }
    it { expect(book.local_timestamp).not_to eq nil }
    it { expect(book.dirty?).to eq true }
  end

  context "Collection" do
    let(:collection) { Aquasync::Collection.new }
    let(:book) { Book.new }
    it {
      collection.push book
      expect(collection.size).to eq 1
    }
  end
end