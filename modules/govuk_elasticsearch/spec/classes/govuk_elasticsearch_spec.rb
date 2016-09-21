require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
  let(:facts) {{
    :fqdn   => 'test.example.com',
    :kernel => 'Linux',
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
  end

  describe '#manage_repo' do
    let(:params) {{
      :version => '1.7.0',
    }}

    context 'true (default)' do
      it { is_expected.to contain_class('govuk_elasticsearch::repo').with_repo_version('1.7') }

      it "should handle the repo for 0.90.x" do
        params[:version] = '0.90.3'
        is_expected.to contain_class('govuk_elasticsearch::repo').with_repo_version('0.90')
      end

      it "should handle the repo for 1.4.x" do
        params[:version] = '1.4.2'
        is_expected.to contain_class('govuk_elasticsearch::repo').with_repo_version('1.4')
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

  describe "destructive actions require name to be used explicitly" do
    let (:params) {{}}

    it "should not be added to 0.90.12" do
      params[:version] = '0.90.12'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('action.destructive_requires_name')
    end

    it "should be added to 1.4.4" do
      params[:version] = '1.4.4'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).to have_key('action.destructive_requires_name')
    end
  end

  describe "disable deletion of all indicies by default" do
    let (:params) {{}}

    it "should be added to 0.90.12" do
      params[:version] = '0.90.12'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).to have_key('action.disable_delete_all_indices')
    end

    it "should not be added to 1.4.4" do
     params[:version] = '1.4.4'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('action.disable_delete_all_indices')
    end
  end

  describe "enabling dynamic scripting" do
    let(:params) {{}}

    it "should not be added to 0.90" do
      params[:version] = '0.90.3'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should not be added for 1.4.2" do
      params[:version] = '1.4.2'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should be added for 1.4.3" do
      params[:version] = '1.4.3'

      instance = subject.call.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]['script.groovy.sandbox.enabled']).to eq(true)
    end
  end

  describe "setting transport firewall rules" do
    let(:params) {{
      :version => '1.7.0',
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
      :version => '1.7.0',
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

  describe "monitoring legacy_elasticsearch" do
    let(:params) {{
      "version" => "1.4.2",
    }}

    it "is true for pre-1.x versions" do
      params["version"] = "0.90.2"

      expect(subject).to contain_class('govuk_elasticsearch::monitoring').with_legacy_elasticsearch(true)
    end

    it "is false for later versions" do
      expect(subject).to contain_class('govuk_elasticsearch::monitoring').with_legacy_elasticsearch(false)
    end
  end
end
