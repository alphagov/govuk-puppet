# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# We don't need rspec-puppet from spec_helper. Just facter.
require 'facter'

describe 'fqdn_short' do
  before :each do
    Facter.clear
  end

  {
    "host-1.vdc.publishing.service.gov.uk"             => "host-1.vdc",
    "host-1.vdc.staging.publishing.service.gov.uk"     => "host-1.vdc.staging",
    "host-1.vdc.integration.publishing.service.gov.uk" => "host-1.vdc.integration",
  }.each do |fqdn, fqdn_short_expected|
    describe "fqdn => #{fqdn}" do
      it {
        expect(Facter.fact(:fqdn)).to receive(:value).and_return(fqdn)
        expect(Facter.fact(:fqdn_short).value).to eq(fqdn_short_expected)
      }
    end
  end
end
