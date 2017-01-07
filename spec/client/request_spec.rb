require 'spec_helper'

describe Request do

  describe ".new" do
    it 'vars set in block are retained' do
      result = Shutterstock::Request.new do |r|
        r.method ('method')
        r.path ('path')
        r.success_status (123)
        r.send_authorization (false)
        r.content_type ('type')
        r.body ('body')
        r.params ('params')
      end

      expect(result.method).to eq 'method'
      expect(result.path).to eq 'path'
      expect(result.success_status).to eq 123
      expect(result.send_authorization).to eq false
      expect(result.content_type).to eq 'type'
      expect(result.body).to eq 'body'
      expect(result.params).to eq 'params'

    end

    it 'can use DSL' do
      result = Shutterstock::Request.new do
        method ('method')
        path ('path')
        success_status (123)
        send_authorization (false)
        content_type ('type')
        body ('body')
        params ('params')
      end

      expect(result.method).to eq 'method'
      expect(result.path).to eq 'path'
      expect(result.success_status).to eq 123
      expect(result.send_authorization).to eq false
      expect(result.content_type).to eq 'type'
      expect(result.body).to eq 'body'
      expect(result.params).to eq 'params'

    end

    it 'can use equals to set' do

      result = Shutterstock::Request.new do |r|
        r.method = 'method'
        r.path = 'path'
        r.success_status = 123
        r.send_authorization = false
        r.content_type = 'type'
        r.body = 'body'
        r.params = 'params'
      end

      expect(result.method).to eq 'method'
      expect(result.path).to eq 'path'
      expect(result.success_status).to eq 123
      expect(result.send_authorization).to eq false
      expect(result.content_type).to eq 'type'
      expect(result.body).to eq 'body'
      expect(result.params).to eq 'params'

    end

    it 'sets sensible defaults' do
      result = Shutterstock::Request.new

      expect(result.success_status).to eq 200
      expect(result.send_authorization).to eq true
      expect(result.content_type).to eq 'application/json'

    end
  end
end
