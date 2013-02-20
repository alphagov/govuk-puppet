require_relative '../../../../spec_helper'

describe 'hosts::skyscape::production_like', :type => :class do
  context 'with website_host not set we expect default behaviour of putting in www.gov.uk' do
    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.test.gov.uk", "www-origin.test.gov.uk", "www.gov.uk"]) }
  end
end 

describe 'hosts::skyscape::production_like', :type => :class do

  before :each do
    update_extdata({'website_host' => 'www.doesnt.exist',})
  end

  #force refresh of the extdata - yes its a hack
  let(:facts) { {:foo => "bar"} }

  context 'with website_host set to a non-default value we expect it in the list' do
    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.test.gov.uk", "www-origin.test.gov.uk", "www.doesnt.exist"]) }
  end
end 




