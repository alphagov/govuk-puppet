require_relative '../../../../spec_helper'

describe 'govuk::app::config', :type => :define do
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
        :domain => 'foo.bar.baz',
        :vhost_full => 'giraffe.foo.bar.baz',
      }
    end

    it do
      should contain_file('/etc/init/giraffe.conf')
      should contain_nginx__config__vhost__proxy('giraffe.foo.bar.baz')
    end
  end

  context 'on the development platform' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'development',
        :domain => 'example.com',
        :vhost_full => 'giraffe.example.com',
      }
    end

    it { should contain_nginx__config__vhost__proxy('giraffe.example.com') }
  end

  context 'with aliases' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'production',
        :vhost_aliases => ['foo','bar'],
        :domain => 'example.com',
        :vhost_full => 'giraffe.example.com',
      }
    end

    it { should contain_nginx__config__vhost__proxy('giraffe.example.com').with_aliases(['foo.example.com','bar.example.com']) }
  end

  context 'without vhost' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :domain => 'example.com',
        :vhost_full => 'giraffe.example.com',
        :enable_nginx_vhost => false,
      }
    end

    it { should_not contain_nginx__config__vhost__proxy('giraffe.example.com') }
  end
end
