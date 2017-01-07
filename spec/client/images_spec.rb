require 'spec_helper'

describe Images do
  before do
    client
  end

  let(:id) { 32_329_852 }
  subject(:images) { Image.find(id).similar  }

  it 'returns similar images' do
    expect(images).to_not be_nil
    expect(images).to be_kind_of Array
    expect(images).to be_kind_of Images
    expect(images[0]).to be_kind_of Image
    expect(images.raw_data).to be_kind_of Hash
    expect(images.page).to be 1
    expect(images.total_count).to eq 200
    expect(images.search_id).to_not be_nil
  end

  describe "fill" do
    it 'fills details of all images in list: all images now have keywords' do
      similar = images
      expect(similar.select{|img| img.keywords.class == Array}.count).to eq 0
      similar.fill
      expect(similar.select{|img| img.keywords.class != Array}.count).to eq 0
    end
  end

end
