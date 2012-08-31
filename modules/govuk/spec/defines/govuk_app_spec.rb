require_relative '../../../../spec_helper'

describe 'govuk::app', :type => :define do
  let(:title) { 'giraffe' }

  context 'with no params' do
    it do
      expect {
        should contain_file('/var/apps/giraffe')
      }.to raise_error(Puppet::Error, /Must pass app_type/)
    end
  end

  context 'with good params' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'production'
      }
    end

    it { should contain_file('/var/apps/giraffe').with_ensure('link') }
    it { should contain_file('/var/run/giraffe') }
    it { should contain_file('/var/log/giraffe') }
    it { should contain_file('/etc/envmgr/giraffe.conf').with_content('') }
    it { should contain_file('/etc/init/giraffe.conf') }
    it { should contain_file('/data/vhost/giraffe.production.alphagov.co.uk') }

    it { should contain_nginx__config__vhost__proxy('giraffe.production.alphagov.co.uk') }
  end

  context 'when specifying environ_source' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'development',
        :environ_source => 'puppet:///foo/bar/baz',
      }
    end

    it { should contain_file('/etc/envmgr/giraffe.conf').with_source('puppet:///foo/bar/baz').without_content }
  end

  context 'when specifying environ_content' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'development',
        :environ_content => 'NECK=very long',
      }
    end

    it { should contain_file('/etc/envmgr/giraffe.conf').with_content('NECK=very long').without_source }
  end

  context 'on the development platform' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'development'
      }
    end

    it { should contain_nginx__config__vhost__proxy('giraffe.dev.gov.uk') }
  end

  context 'with aliases' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'production',
        :vhost_aliases => ['foo','bar']
      }
    end

    it { should contain_nginx__config__vhost__proxy('giraffe.production.alphagov.co.uk').with_aliases(['foo.production.alphagov.co.uk','bar.production.alphagov.co.uk']) }
  end

end
