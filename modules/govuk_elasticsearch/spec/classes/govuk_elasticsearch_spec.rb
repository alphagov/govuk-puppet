require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
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

  describe '#use_mirror' do
    let(:facts) {{
      :kernel => 'Linux',
    }}

    context 'true (default)' do
      let(:params) {{
        :version => '1.2.3',
      }}

      it { should contain_class('govuk_elasticsearch::repo') }
      it { should contain_class('elasticsearch').with_manage_repo(false) }
    end

    context 'false' do
      let(:params) {{
        :version    => '1.2.3',
        :use_mirror => false,
      }}

      it { should_not contain_class('govuk_elasticsearch::repo') }
      it { should contain_class('elasticsearch').with_manage_repo(true) }
    end
  end
end
