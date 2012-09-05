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

    it do
      should contain_govuk__app__package('giraffe').with(
        'vhost_full' => 'giraffe.production.alphagov.co.uk',
        'platform' => 'production',
      )
      should contain_govuk__app__config('giraffe').with(
        'domain' => 'production.alphagov.co.uk',
      )
      should contain_service('giraffe').with_provider('upstart')
    end
  end

  context 'on the development platform' do
    let(:params) do
      {
        :port => 8000,
        :app_type => 'rack',
        :platform => 'development'
      }
    end

    it { should contain_govuk__app__config('giraffe').with_vhost_full('giraffe.dev.gov.uk') }
  end
end
