# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# We don't need rspec-puppet from spec_helper. Just facter.
require 'facter'

describe 'fqdn_underscore' do
  before :each do
    Facter.clear
  end

  {
    "host.example.com"    => "host_example_com",
    "host-1.example.com"  => "host-1_example_com",
  }.each do |fqdn, fqdn_underscore|
    describe "fqdn => #{fqdn}" do
      it {
        Facter.fact(:fqdn).should_receive(:value).and_return(fqdn)
        Facter.fact(:fqdn_underscore).value.should == fqdn_underscore
      }
    end
  end
end
