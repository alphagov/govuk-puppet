require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::static', :type => :define do
  let(:title) { 'static.example.com' }

  context 'with no params' do
    it 'should proxy to server localhost:8080' do
      should contain_nginx__config__site('static.example.com').with_content(/server localhost:8080/)
    end
  end

  context 'with backend specified' do
    let(:params) do
      {
        :to => 'giraffe:1234',
      }
    end
    it 'should proxy to server giraffe:1234' do
      should contain_nginx__config__site('static.example.com').with_content(/server giraffe:1234/)
    end
  end
end
