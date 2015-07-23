require_relative '../../../../spec_helper'

describe 'govuk::ppa', :type => :class do
  describe '#path' do
    context 'production (default)' do
      let(:params) {{
        :apt_mirror_hostname => 'apt.example.com',
      }}

      it { should contain_apt__source('govuk-ppa').with_location('http://apt.example.com/govuk/ppa/production') }
    end

    context 'preview' do
      let(:params) {{
        :apt_mirror_hostname => 'apt.example.com',
        :path => 'preview',
      }}

      it { should contain_apt__source('govuk-ppa').with_location('http://apt.example.com/govuk/ppa/preview') }
    end
  end

  describe '#use_mirror' do
    context 'true (default)' do
      let(:params) {{ }}

      it { should contain_apt__source('govuk-ppa') }
    end

    context 'false' do
      let(:params) {{
        :use_mirror => false,
      }}

      it { should contain_apt__ppa('ppa:gds/govuk') }
    end
  end
end
