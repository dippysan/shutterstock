require 'spec_helper'

describe Models do
  before do
    client
  end

  subject(:models) { Image.find(356308322).models  }

  it 'returns all models for an image' do
    expect(models).to_not be_nil
    expect(models).to be_kind_of Array
    expect(models).to be_kind_of Models
    expect(models[0]).to be_kind_of Model
    expect(models.raw_data).to be_kind_of Array
  end

  it 'parses params correctly' do
    expect(models[0].id).to eq 17856134
    expect(models[1].id).to eq 15233887
  end

end
