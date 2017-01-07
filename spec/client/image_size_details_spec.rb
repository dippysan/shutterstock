require 'spec_helper'

describe ImageSizeDetails do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes params correctly' do
      isd = ImageSizeDetails.new({"display_name" => "Huge","dpi" => 300,"file_size" => 1103872,"format" => "jpg","height" => 5000,"is_licensable" => false,"width" => 5000})

      expect(isd.name).to eq "Huge"
      expect(isd.display_name).to eq "Huge"
      expect(isd.dpi).to eq 300
      expect(isd.file_size).to eq 1103872
      expect(isd.format).to eq "jpg"
      expect(isd.height).to eq 5000
      expect(isd.is_licensable).to eq false
      expect(isd.licensable?).to eq false
      expect(isd.width).to eq 5000
    end

    it 'initializes correctly when some params missing' do
      isd = ImageSizeDetails.new({"display_name" => "Huge","file_size" => 1103872,"format" => "jpg","is_licensable" => false})

      expect(isd.display_name).to eq "Huge"
      expect(isd.dpi).to be nil
      expect(isd.height).to be nil
      expect(isd.width).to  be nil
    end
  end

end
