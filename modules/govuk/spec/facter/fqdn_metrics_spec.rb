# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require_relative '../../../../spec_helper'
require 'facter'

describe 'fqdn_metrics' do
  before :each do
    Facter.clear
  end

  {
    "host.example.com"                          => "host_example_com",
    "host-1.example.com"                        => "host-1_example_com",
    "host-1.example.publishing.service.gov.uk"  => "host-1_example",
  }.each do |fqdn, fqdn_metrics|
    describe "fqdn => #{fqdn}" do
      it {
        expect(Facter.fact(:fqdn)).to receive(:value).and_return(fqdn)
        expect(Facter.fact(:fqdn_metrics).value).to eq(fqdn_metrics)
      }
    end
  end
end
