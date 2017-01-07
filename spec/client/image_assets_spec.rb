require 'spec_helper'

describe ImageAssets do
  before do
    client
  end

  let(:id) { 402_160_099 }
  subject(:assets) { Image.find(id).assets  }

  describe "find" do
    it 'places image data into correct fields' do
      # Test variables from this specific API call.
      # Might break if vcr recording is deleted. If so, use new values

      expect(assets.small_jpg).to be_a ImageSizeDetails
      expect(assets.small_jpg.height).to eq 375
      expect(assets.medium_jpg).to be_a ImageSizeDetails
      expect(assets.huge_jpg).to be_a ImageSizeDetails
      expect(assets.supersize_jpg).to be_a ImageSizeDetails
      expect(assets.huge_tiff).to be_a ImageSizeDetails
      expect(assets.supersize_tiff).to be_a ImageSizeDetails
      expect(assets.vector_eps).to be nil
      expect(assets.small_thumb).to be_a Thumbnail
      expect(assets.large_thumb).to be_a Thumbnail
      expect(assets.preview).to be_a Thumbnail
      expect(assets.preview_1000).to be nil
      expect(assets.preview_1500).to be nil

      expect(assets.count).to be 9

    end

    it 'calculates fields correctly' do

      # Test variables from this specific API call.
      # Might break if vcr recording is deleted. If so, use new values

      expect(assets.small).to eq assets.small_jpg
      expect(assets.medium).to eq assets.medium_jpg
      expect(assets.huge).to eq assets.huge_jpg
      expect(assets.supersize).to eq assets.supersize_jpg

      expect(assets.largest_jpg).to eq assets.supersize
      expect(assets.largest_tiff).to eq assets.supersize_tiff
      expect(assets.largest_preview).to eq assets.preview

    end
  end

end
