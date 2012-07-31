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
        :app_type => 'rails',
        :platform => 'production'
      }
    end

    it { should contain_file('/var/apps/giraffe').with_ensure('link') }
    it { should contain_file('/var/run/giraffe') }
    it { should contain_file('/var/log/giraffe') }
    it { should contain_file('/etc/envmgr/giraffe.conf') }
    it { should contain_file('/etc/init/giraffe.conf') }
    it { should contain_file('/data/vhost/giraffe.production.alphagov.co.uk') }

    it { should contain_nginx__config__vhost__proxy('giraffe.production.alphagov.co.uk') }
    it { should contain_govuk__app__monitoring('giraffe') }
  end

  context 'on the development platform' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rails',
        :platform => 'development'
      }
    end

    it { should contain_nginx__config__vhost__dev_proxy('giraffe.dev.gov.uk') }
  end

  context 'with aliases' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rails',
        :platform => 'production',
        :vhost_aliases => ['foo']
      }
    end

    it { should contain_nginx__config__vhost__proxy('giraffe.production.alphagov.co.uk').with_aliases('foo.production.alphagov.co.uk') }
  end

end
