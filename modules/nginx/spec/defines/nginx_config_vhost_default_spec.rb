require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::default', :type => :define do
  let(:title) { 'donkey' }
  let(:facts) do
    { :govuk_platform => 'production' }
  end

  context 'with no params' do
    it 'should install a default vhost that 404s' do
      should contain_nginx__config__site('donkey')
        .with_content(/server_name\s+default_server;/)
        .with_content(/return\s+404;/)
    end
  end

  context 'with a specified status code' do
    let(:params) do
      { :status => '418' }
    end
    it 'should install a default vhost that returns that status code' do
      should contain_nginx__config__site('donkey')
        .with_content(/server_name\s+default_server;/)
        .with_content(/return\s+418;/)
    end
  end
end
