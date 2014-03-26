require_relative '../../../../spec_helper'

describe 'hosts', :type => :class do
  let(:hiera_data) {{
    'app_domain' => 'test.gov.uk',
  }}

  context 'node jumpbox-1 exists in hosts::production' do
    let(:node) { 'jumpbox-1' }

    it 'should purge unmanaged hosts entries' do
      should contain_govuk__host('jumpbox-1')
      should contain_resources('host').with_purge('true')
    end
  end

  context 'node foo-bar-wibble does NOT exist in hosts::production' do
    let(:node) { 'foo-bar-wibble' }

    it 'should abort catalog so as not to purge hosts entry for self' do
      expect { should }.to raise_error(Puppet::Error, /Unable to find Govuk::Host\[foo-bar-wibble\]/)
    end
  end
end
