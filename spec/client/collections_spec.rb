require 'spec_helper'

describe Collections do
  before do
    client
  end

  subject(:collections) { Collection.list  }

  it 'returns all collections for current user' do
    expect(collections).to_not be_nil
    expect(collections).to be_kind_of Array
    expect(collections).to be_kind_of Collections
    expect(collections[0]).to be_kind_of Collection
    expect(collections.raw_data).to be_kind_of Hash
  end

end
