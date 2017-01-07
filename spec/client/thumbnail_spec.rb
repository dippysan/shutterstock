require 'spec_helper'

describe Thumbnail do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes params correctly' do
      isd = Thumbnail.new({"height" => 299,
                           "url" => "https://image.shutterstock.com/xxx.jpg",
                           "width" => 450})

      expect(isd.height).to eq 299
      expect(isd.url).to eq "https://image.shutterstock.com/xxx.jpg"
      expect(isd.width).to eq 450
    end

  end

end
