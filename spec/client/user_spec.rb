require 'spec_helper'

describe User do
  before do
    client
  end

  context 'find' do

    subject { User.find }

    it 'returns object for current user' do
      expect(subject).to_not be_nil
      expect(subject).to be_a User
    end

    it 'parses info on user correctly' do
      expect(subject.contributor_id).to be nil
      expect(subject.customer_id).to eq ENV["SSTK_CUSTOMER_ID"]
      expect(subject.email).to be nil
      expect(subject.first_name).to eq ENV["SSTK_FIRST_NAME"]
      expect(subject.full_name).to eq ENV["SSTK_FULL_NAME"]
      expect(subject.id).to eq ENV["SSTK_USER_ID"]
      expect(subject.last_name).to eq ENV["SSTK_LAST_NAME"]
      expect(subject.language).to eq "en"
      expect(subject.organization_id).to eq nil
      expect(subject.username).to eq ENV["SSTK_USERNAME"]
      expect(subject.is_premier).to eq nil
      expect(subject.is_premier_parent).to eq nil
      expect(subject.premier_permissions).to eq nil
      expect(subject.only_sensitive_use).to eq nil
      expect(subject.only_enhanced_license).to eq nil
    end

  end

end
