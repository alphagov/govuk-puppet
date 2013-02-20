require_relative '../../../../spec_helper'

# Ideally this would also include a context for testing the converse.
# Sadly due to MockExtData and a finite amound of patience, I have failed.

describe 'hosts::skyscape::production_like', :type => :class do
  context 'with govuk_host_alias: yes' do
    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.test.gov.uk", "www-origin.test.gov.uk", "www.gov.uk"]) }
  end
end 
