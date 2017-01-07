require 'spec_helper'

describe Model do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes with ID from params' do
      expect(Model.new("id" => 1234).id).to be 1234
    end
  end

end
