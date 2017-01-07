require 'spec_helper'

describe Image do
  before do
    client
  end

  let(:id) { 118_139_110 }
  subject(:image) { Image.find(id)  }

  describe "find" do
    it 'returns an Image object' do
      expect(Image).to respond_to(:find)
      expect(image).to_not be_nil

      expect(image.id).to eql id
      expect(image.assets).to be_a ImageAssets
    end

    it 'places image data into correct fields' do
      # Test variables from this specific API call.
      # Might break if vcr recording is deleted. If so, use new values
      expect(image.added).to eq DateTime.parse("2012-11-09T00:00:00+00:00")
      expect(image.adult?).to eq false
      expect(image.aspect).to eq 1.5
      expect(image.assets.count).to eq 9
      expect(image.assets.preview).to be_a Thumbnail
      expect(image.assets.small).to be_a ImageSizeDetails
      expect(image.assets.preview.url).to match /118139110/
      expect(image.categories).to be_a Categories
      expect(image.categories[0]).to be_a Category
      expect(image.categories[0].id).to eq 1
      expect(image.contributor).to be_a Contributor
      expect(image.contributor.id).to eq 1306729
      expect(image.description).to eq "Adorable Labrador Puppy Playing with a Chew Toy on White Backdrop"
      expect(image.editorial?).to eq false
      expect(image.illustration?).to eq false
      expect(image.image_type).to eq "photo"
      expect(image.keywords).to be_a Array
      expect(image.keywords.count).to eq 20
      expect(image.media_type).to eq "image"
      expect(image.model_release?).to eq false
      expect(image.model_releases).to eq nil
      expect(image.models).to eq nil
      expect(image.property_release?).to eq false
    end

    it 'places more image data into correct fields' do
      # Tests model releases
      # Might break if vcr recording is deleted. If so, use new values
      another = Image.find(356308322)
      expect(another.model_release?).to eq true
      expect(another.model_releases).to eq nil
      expect(another.models).to be_a Models
      expect(another.models[0]).to be_a Model
      expect(another.models[0].id).to eq 17856134
    end

  end

  describe "similar" do
    it 'returns similar images' do
      result = Image.similar(id)
      expect(result).to_not be_nil
      expect(result).to be_kind_of Array
      expect(result).to be_kind_of Images
      expect(result[0]).to be_kind_of Image
      expect(result.raw_data).to be_kind_of Hash
      expect(result.page).to be 1
      expect(result.total_count).to eq 200
      expect(result.search_id).to_not be_nil

      # ["count", "page", "sort_method", "search_id", "data"]
    end

    it 'finds similar images, given an image' do
      expect(image.similar).to be_kind_of Images
    end
  end

  describe "search" do
    it 'searches for images based on searchterm' do
      results = Image.search('purple cat')
      expect(results).to be_kind_of Images
      expect(results.size).to be > 1
    end

    it 'searches using more than one parameter' do
      results = Image.search({query: 'laughing', people_age: 'teenagers', sort: 'popular'})
      expect(results).to be_kind_of Images
      expect(results.size).to be > 1
    end
  end

  describe "fill" do
    it 'fills all details of current image' do
      unfilled = Image.new("id" => 118_139_110)
      unfilled.fill
      expect(unfilled.description).to eq subject.description
    end
  end
end
