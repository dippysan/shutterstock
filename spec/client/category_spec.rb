require 'spec_helper'

describe Category do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes with ID and Name from params' do
      category = Category.new("id" => 1234, "name" => "dog")
      expect(category.id).to be 1234
      expect(category.name).to eq "dog"
    end
  end

end
