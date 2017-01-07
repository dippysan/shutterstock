require 'spec_helper'

describe Collection do
  $new_collection_id = nil

  before do
    client
  end

  context 'find' do
    let(:id) { 23_712_632 }
    let(:image_id) { 88_028_233 }
    let(:new_image_id) { 550_104_544 }
    subject(:collection) { Collection.find(id) }

    it 'finds a collection, given an id' do
      expect(Collection).to respond_to(:find)

      expect(collection).to_not be_nil
      expect(collection.id).to eql id
      expect(collection.name.size).to be > 2
      expect(collection.total_count).to be > 0
      expect(collection.items_updated).to be_a DateTime
      expect(collection.cover_item).to be_a Image
      expect(collection.cover_item.id).to eq new_image_id
    end

    it 'converts list to images' do
      items = collection.items
      expect(items).to be_kind_of Images
      expect(items[0]).to be_kind_of Image
    end

    it 'raises error for invalid collection id' do
      test_id = 12_345_678
      expect { Collection.find(test_id) }.to raise_error(FailedResponse)
    end

    it 'adds an image' do
      expect { collection.add_image(new_image_id) }.not_to raise_error
    end

    it 'removes an image' do
      expect { collection.remove_image(new_image_id) }.not_to raise_error
    end
  end

  context do

    context 'create' do

      it 'raises ArgumentError if no collection_name' do
        expect { Collection.create() }.to raise_error(ArgumentError)
      end

      it 'creates a collection' do
        collection = Collection.create('test_collection')
        expect(collection).to be_an_instance_of(Collection)
        expect(collection.id).to be_an Integer
        $new_collection_id = collection.id
        expect(collection.name).to eql 'test_collection'
      end

    end

    context 'list' do
      it 'returns all collections for the current user' do
        result = Collection.list
        expect(result).to_not be_nil
        expect(result).to be_kind_of Array
        expect(result).to be_kind_of Collections
        expect(result[0]).to be_kind_of Collection
      end

      it 'raises error on unsuccessful update' do

        test_id = 99999 # creates error in mock
        expect { Collection.update(id: test_id, name: 'test_collection_new_name') }.to raise_error(FailedResponse)
      end
    end

    context 'update' do
      it 'raises ArgumentError if no collection_name' do
        expect { Collection.update() }.to raise_error(ArgumentError)
      end

      it 'changes the name of a collection' do
        expect { Collection.update(id: $new_collection_id, name: 'test_collection_new_name') }.not_to raise_error
        expect(Collection.find($new_collection_id).name).to eq 'test_collection_new_name'
      end

      it 'raises error on unsuccessful update' do

        test_id = 99999 # creates error in mock
        expect { Collection.update(id: test_id, name: 'test_collection_new_name') }.to raise_error(FailedResponse)
      end
    end

    context 'destroy' do
      it 'destroys a collection' do
        expect { Collection.destroy($new_collection_id) }.not_to raise_error
        expect { Collection.find($new_collection_id) }.to raise_error(FailedResponse)
      end

      it 'raises error on unsucessful delete' do
        test_id = 99999
        expect { Collection.destroy(test_id) }.to raise_error(FailedResponse)
      end
    end

    context 'add_image' do
      let(:id) { 23_712_632 }
      let(:bad_collection_id) { 54_321 }
      let(:image_id) { 123_456_987_654_321 }
      context 'error' do
        it 'raises ArgumentError if no collection_id or image_id' do
          expect { Collection.add_image(image_id: image_id) }.to raise_error(ArgumentError)
          expect { Collection.add_image(id: bad_collection_id) }.to raise_error(ArgumentError)
        end

        it 'raises error if collection does not exist' do
          expect { Collection.add_image(id: bad_collection_id, image_id: image_id) }.to raise_error(FailedResponse)
        end

      end

      it 'adds image using id' do
        expect { Collection.add_image(id: id, image_id: image_id) }.not_to raise_error
      end

      it 'adds image using Image.new' do
        expect { Collection.add_image(id: id, image_id: Image.new("id" => image_id)) }.not_to raise_error
      end
    end

    context 'remove_image' do
      let(:id) { 23_712_632 }
      let(:image_id) { 987_654_321 }

      context 'error' do
        it 'raises ArgumentError if no collection_id or image_id' do
          expect { Collection.remove_image(image_id: image_id) }.to raise_error(ArgumentError)
          expect { Collection.remove_image(id: id) }.to raise_error(ArgumentError)
        end

      end

      it 'removes image using id' do
        expect { Collection.remove_image(id: id, image_id: image_id) }.not_to raise_error
      end

      it 'removes image using Image.new' do
        expect { Collection.remove_image(id: id, image_id: Image.new("id" => image_id)) }.not_to raise_error
      end
    end

  end

end
