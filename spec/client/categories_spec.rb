require 'spec_helper'

describe Categories do
  before do
    client
  end

  subject(:cats) { Image.find(356308322).categories  }

  it 'returns all cats for an image' do
    expect(cats).to_not be_nil
    expect(cats).to be_kind_of Array
    expect(cats).to be_kind_of Categories
    expect(cats[0]).to be_kind_of Category
    expect(cats.raw_data).to be_kind_of Array
  end

  it 'parses params correctly' do
    expect(cats.count).to eq 2
    expect(cats[0].id).to eq 13
    expect(cats[0].name).to eq "People"
    expect(cats[1].id).to eq 20
    expect(cats[1].name).to eq "NOT-CATEGORIZED"
  end

end
