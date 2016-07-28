require_relative '../../../../spec_helper'

describe 'govuk::app::envvar::redis', :type => :define do
  let(:title) { 'giraffe' }

  context 'with empty parameters' do
    let(:params) { {} }

    it 'sets the Redis host to 127.0.0.1 by default' do
      is_expected.to contain_govuk__app__envvar("#{title}-redis_host")
                       .with_app(title)
                       .with_varname('REDIS_HOST')
                       .with_value('127.0.0.1')
    end

    it 'sets the Redis port to 6379 by default' do
      is_expected.to contain_govuk__app__envvar("#{title}-redis_port")
                       .with_app(title)
                       .with_varname('REDIS_PORT')
                       .with_value('6379')
    end
  end

  context 'with some good parameters' do
    let(:host) { 'redis.backend' }
    let(:port) { 1234 }
    let(:params) { { host: host, port: port } }

    it 'sets the Redis host' do
      is_expected.to contain_govuk__app__envvar("#{title}-redis_host")
                       .with_app(title)
                       .with_varname('REDIS_HOST')
                       .with_value(host)
    end

    it 'sets the Redis port' do
      is_expected.to contain_govuk__app__envvar("#{title}-redis_port")
                       .with_app(title)
                       .with_varname('REDIS_PORT')
                       .with_value(port)
    end
  end
end
