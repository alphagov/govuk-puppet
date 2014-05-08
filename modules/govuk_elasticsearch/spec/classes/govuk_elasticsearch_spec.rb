require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
  describe '#use_mirror' do
    context 'true (default)' do
      let(:params) {{
        :version => '1.2.3',
      }}

      it { should contain_class('govuk_elasticsearch::repo') }
      it { should contain_class('elasticsearch_old').with_manage_repo(false) }
    end

    context 'false' do
      let(:params) {{
        :version    => '1.2.3',
        :use_mirror => false,
      }}

      it { should_not contain_class('govuk_elasticsearch::repo') }
      it { should contain_class('elasticsearch_old').with_manage_repo(true) }
    end
  end
end
