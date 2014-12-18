require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch', :type => :class do
  describe '#use_mirror' do
    let(:facts) {{
      :kernel      => 'Linux',
      :configdir   => '/woody',
      :package_dir => '/rex',
      :installpath => '/slinky/dog',
      :plugindir   => '/mr/potato/head',
      :plugintool  => 'bopeep',
      :datadir     => '/buzz/lightyear',
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
