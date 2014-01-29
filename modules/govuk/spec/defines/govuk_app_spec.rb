require_relative '../../../../spec_helper'

describe 'govuk::app', :type => :define do
  let(:title) { 'giraffe' }
  let(:hiera_data) {{
      'app_domain'   => 'test.gov.uk',
      'website_root' => 'foo.test.gov.uk',
    }}

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
      }
    end

    it do
      should contain_govuk__app__package('giraffe').with(
        'vhost_full' => 'giraffe.test.gov.uk',
      )
      should contain_govuk__app__config('giraffe').with(
        'domain' => 'test.gov.uk',
      )
      should contain_service('giraffe').with_provider('upstart')
    end
  end

  context 'app_type => bare, without command' do
    let(:params) {{
      :app_type => 'bare',
      :port     => 123,
    }}

    it { expect { should }.to raise_error(Puppet::Error, /Invalid \$command parameter/) }
  end

end
