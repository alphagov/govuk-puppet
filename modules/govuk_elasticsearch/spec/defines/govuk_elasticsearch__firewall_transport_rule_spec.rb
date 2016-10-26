require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch::firewall_transport_rule', :type => :define do

  context "with a bare hostname" do
    let(:title) { @title }
    let(:params) {{}}
    let(:facts) {{
      :ipaddress_eth0 => '10.10.10.10',
    }}

    let(:pre_condition) {
      <<-EOT
      # Realise the virtual resources so they get added to the catalogue
      Ufw::Allow <| |>

      govuk_host { 'giraffe':
        ip  => '10.0.0.1',
        vdc => 'test',
      }
      EOT
    }

    it "should create a rule using the default port" do
      @title = "giraffe"

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-giraffe')
        .with_from('10.0.0.1')
        .with_port('9300')
    end

    it "should extract the hostname from a fqdn" do
      @title = "giraffe.example.com"

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-giraffe')
        .with_from('10.0.0.1')
        .with_port('9300')
    end

    it "should do nothing with a hostname of 'localhost'" do
      @title = "localhost"

      expect(subject).to have_ufw__allow_resource_count(0)
    end

    it "should allow overriding the port" do
      @title = "giraffe:9302"

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9302-from-giraffe')
        .with_from('10.0.0.1')
        .with_port('9302')
    end

    it "should error if referencing an undefined host" do
      @title = "non-existent"

      expect {
        subject.call
      }.to raise_error(Puppet::Error, /Could not find govuk_host instance for non-existent/)
    end

    it "should error if given garbage input" do
      [
        'non-numeric:abcd',
        'under_score',
        'multi-port:123:456',
      ].each do |title|
        @title = title

        expect {
          subject.call
        }.to raise_error(Puppet::Error, /is not in the form hostname:port/)
      end
    end
  end
end
