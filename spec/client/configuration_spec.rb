require 'spec_helper'

describe Configuration do
  subject { Configuration.new }

  it 'should return api_url when set' do
    subject.api_url = 'https://api.shutterstock.com/newurl'
    expect(subject.api_url).to eql('https://api.shutterstock.com/newurl')
  end
end
