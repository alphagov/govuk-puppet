require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
  let(:facts) {{
    :fqdn           => 'test.example.com',
    :ipaddress_eth0 => '10.10.10.10',
    :kernel         => 'Linux',
    :puppetversion  => '3.8.6',
    :rubyversion    => '1.9.3',
  }}

  describe '#version' do

    context "when not set" do
      it { is_expected.to raise_error(Puppet::Error, /Must pass version/) }
    end

    context "when set to 'present'" do
      let(:params) {{
        :version => 'present',
      }}

      it { is_expected.to raise_error(Puppet::Error, /must be in the form x\.y\.z/) }
    end

    context "when set to 1.7.1" do
      let(:params) {{
        :version => '1.7.1',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Unsupported version of elasticsearch/) }
    end

    context "when set to 2.4.3" do
      let(:params) {{
        :version => '2.4.3',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Unsupported version of elasticsearch/) }
    end
  end

  describe '#manage_repo' do
    let(:params) {{
      :version => '5.1.0',
    }}

    context 'true (default)' do
      it { is_expected.to contain_class('govuk_elasticsearch::repo').with_repo_version('5.x') }

      it "should handle the repo for 5.6.x" do
        params[:version] = '5.6.14'
        is_expected.to contain_class('govuk_elasticsearch::repo').with_repo_version('5.x')
      end

      it { is_expected.to contain_class('elasticsearch').with_manage_repo(false) }
    end

    context 'false' do
      before :each do
        params[:manage_repo] = false
      end

      it { is_expected.not_to contain_class('govuk_elasticsearch::repo') }
      it { is_expected.to contain_class('elasticsearch').with_manage_repo(false) }
    end
  end

  describe "setting transport firewall rules" do
    let(:params) {{
      :version => '5.6.14',
      :open_firewall_from_all => false,
    }}

    let(:pre_condition) {
      <<-EOT
      # Realise the virtual resources so they get added to the catalogue
      Ufw::Allow <| |>

      govuk_host { 'test-1':
        ip  => '10.0.0.1',
        vdc => 'foo',
      }
      govuk_host { 'test-2':
        ip  => '10.0.0.2',
        vdc => 'foo',
      }
      EOT
    }

    it "should not create any rules by default" do
      expect(subject).to have_ufw__allow_resource_count(0)
    end

    it "should create an allow rule for each cluster host" do
      params[:cluster_hosts] = ["test-1", "test-2"]

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-test-1')
        .with_from('10.0.0.1')
        .with_port('9300')
      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-test-2')
        .with_from('10.0.0.2')
        .with_port('9300')
    end

    it "should support host:port style cluster hosts" do
      params[:cluster_hosts] = ["test-1:9300", "test-2:9301"]

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-test-1')
        .with_from('10.0.0.1')
        .with_port('9300')
      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9301-from-test-2')
        .with_from('10.0.0.2')
        .with_port('9301')
    end

    it "should support hostname.vdc style hosts" do
      params[:cluster_hosts] = ["test-1.foo", "test-2.foo:9301"]

      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9300-from-test-1')
        .with_from('10.0.0.1')
        .with_port('9300')
      expect(subject).to contain_ufw__allow('allow-elasticsearch-transport-9301-from-test-2')
        .with_from('10.0.0.2')
        .with_port('9301')
    end
  end

  describe "firewall rules" do
    let(:params) {{
      :version => '5.6.14',
    }}

    let(:pre_condition) {
      # Realise the virtual resources so they get added to the catalogue
      "Ufw::Allow <| |>"
    }

    it "should be closed by default" do
      expect(subject).to have_ufw__allow_resource_count(0)
    end

    it "should be open when requested" do
      params[:open_firewall_from_all] = true

      expect(subject).to contain_ufw__allow('allow-elasticsearch-http-9200-from-all')
    end
  end
end
