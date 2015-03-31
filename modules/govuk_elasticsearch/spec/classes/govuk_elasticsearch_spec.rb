require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
  let(:facts) {{
    :fqdn   => 'test.example.com',
    :kernel => 'Linux',
  }}

  describe '#version' do

    context "when not set" do
      it { expect { should }.to raise_error(Puppet::Error, /Must pass version/) }
    end

    context "when set to 'present'" do
      let(:params) {{
        :version => 'present',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /must be in the form x\.y\.z/) }
    end
  end

  describe '#manage_repo' do
    let(:params) {{
      :version => '1.2.3',
    }}

    context 'true (default)' do
      it { should contain_class('govuk_elasticsearch::repo').with_repo_version('1.2') }

      it "should handle the repo for 0.90.x" do
        params[:version] = '0.90.3'
        should contain_class('govuk_elasticsearch::repo').with_repo_version('0.90')
      end

      it "should handle the repo for 1.4.x" do
        params[:version] = '1.4.2'
        should contain_class('govuk_elasticsearch::repo').with_repo_version('1.4')
      end

      it { should contain_class('elasticsearch').with_manage_repo(false) }
    end

    context 'false' do
      before :each do
        params[:manage_repo] = false
      end

      it { should_not contain_class('govuk_elasticsearch::repo') }
      it { should contain_class('elasticsearch').with_manage_repo(false) }
    end
  end

  describe "enabling dynamic scripting" do
    let(:params) {{}}

    it "should not be added to 0.90" do
      params[:version] = '0.90.3'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should not be added for 1.4.2" do
      params[:version] = '1.4.2'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should be added for 1.4.3" do
      params[:version] = '1.4.3'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]['script.groovy.sandbox.enabled']).to eq(true)
    end
  end

  describe "monitoring legacy_elasticsearch" do
    let(:params) {{
      "version" => "1.4.2",
    }}

    it "is true for pre-1.x versions" do
      params["version"] = "0.90.2"

      subject.should contain_class('govuk_elasticsearch::monitoring').with_legacy_elasticsearch(true)
    end

    it "is false for later versions" do
      subject.should contain_class('govuk_elasticsearch::monitoring').with_legacy_elasticsearch(false)
    end
  end
end
