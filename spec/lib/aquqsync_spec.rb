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
    let(:master) { Aquasync::MasterCollection.instance }

    it {
      collection.push book
      expect(collection.size).to eq 1
    }

    it {
      dbook = Book.new
      dbook.destroy

      collection.push dbook
      expect(collection.size).to eq 0
    }

    context '#push_sync' do
      before(:each) do
        book1 = Book.new
        book2 = Book.new
        collection.push book1
        collection.push book2
      end

      it("dirty resources size should eq 2") {
        expect(collection.dirty_resources.size).to eq 2
      }

      it("should push 2 dirty records to master successfully") {
        collection.push_sync
        expect(master.collection.size).to eq 2
      }

      it("should not push records for duplicated #push_sync") {
        collection.push_sync
        collection.push_sync
        expect(master.collection.size).to eq 2
      }

    end
  end
end