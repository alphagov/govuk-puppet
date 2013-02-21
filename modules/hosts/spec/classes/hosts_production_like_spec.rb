require_relative '../../../../spec_helper'

describe 'hosts::skyscape::production_like', :type => :class do
  context 'with website_host => www.gov.uk (default)' do
    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.test.gov.uk", "www-origin.test.gov.uk", "www.gov.uk"]) }
  end

  context 'with website_host => www.doesnt.exist' do
    before :each do
      update_extdata({'website_host' => 'www.doesnt.exist',})
    end

    #force refresh of the extdata - yes its a hack
    let(:facts) {{ :foo => "bar" }}

    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.test.gov.uk", "www-origin.test.gov.uk", "www.doesnt.exist"]) }
  end
end 
