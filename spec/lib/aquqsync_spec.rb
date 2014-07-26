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
    let(:local_store) { Aquasync::LocalStore.instance }

    before(:each) do
      local_store.device_token = "testdevicetoken"
      local_store.latest_ust = 0
    end

    it("should be able to add a model") {
      collection.push book
      expect(collection.size).to eq 1
    }

    it("should not count deleted model on #size") {
      dbook = Book.new
      dbook.destroy

      collection.push dbook
      expect(collection.size).to eq 0
    }

    context '#push_sync' do
      before(:each) do
        master.drop_all
        book1 = Book.new
        book2 = Book.new
        collection.push book1
        collection.push book2
      end

      context "one collection" do

        it("dirty resources size should eq 2") {
          expect(collection.dirty_resources.size).to eq 2
        }

        it("should push 2 dirty records to master successfully") {
          collection.push_sync
          expect(master.collection.size).to eq 2
        }

        it("should undirty resources after #push_sync") {
          collection.push_sync
          expect(collection.dirty_resources.size).to eq 0
        }

        it("should not send duplicated deltas for duplicated #push_sync") {
          collection.push_sync
          collection.push_sync
          expect(master.collection.size).to eq 2
        }

        it("should send deltas which is created after last #push_sync") {
          collection.push_sync
          book3 = Book.new
          collection.push book3
          collection.push_sync
          expect(master.collection.size).to eq 3
        }

        it("should pull nothing at #pull_sync after #push_sync performed") {
          collection.push_sync
          collection.pull_sync

          expect(collection.size).to eq 2
        }

        it("should send deltas which is modified after last #push_sync") {
          collection.push_sync
          collection.first.update_attribute(:name, "The Little Prince")
          collection.push_sync

          expect(master.collection.size).to eq 2
        }

        it("should send deltas which is modified after last #push_sync") {
          collection.push_sync
          collection.first.update_attribute(:name, "The Little Prince")
          collection.push_sync

          expect(master.collection.first.name).to eq "The Little Prince"
        }
      end

      context "two collections" do
        let(:collection2) { Aquasync::Collection.new }
        before(:each) do
          book3 = Book.new
          book4 = Book.new
          book5 = Book.new
          collection2.push book3
          collection2.push book4
          collection2.push book5
        end

        it("should merge deltas from two collections") {
          collection.push_sync
          collection2.push_sync

          expect(master.collection.size).to eq 5
        }

        it("should merge merged collections on master to local collection") {
          collection.push_sync
          collection2.push_sync

          collection.pull_sync
          collection2.pull_sync

          expect(collection.size).to eq 5
          expect(collection2.size).to eq 5
        }
      end



    end
  end
end