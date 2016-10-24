require_relative '../../../../spec_helper'

describe 'govuk_ppa', :type => :class do
  let (:facts) {{
    :lsbdistcode    => 'trusty',
    :lsbdistid      => 'Ubuntu',
    :lsbdistrelease => '14.04',
  }}
  describe '#path' do
    context 'production (default)' do
      let(:params) {{
        :apt_mirror_hostname => 'apt.example.com',
      }}

      it { is_expected.to contain_apt__source('govuk-ppa').with_location('http://apt.example.com/govuk/ppa/production') }
    end

    context 'another environment' do
      let(:params) {{
        :apt_mirror_hostname => 'apt.example.com',
        :path => 'another-environment',
      }}

      it { is_expected.to contain_apt__source('govuk-ppa').with_location('http://apt.example.com/govuk/ppa/another-environment') }
    end
  end

  describe '#use_mirror' do
    context 'true (default)' do
      let(:params) {{ }}

      it { is_expected.to contain_apt__source('govuk-ppa') }
    end

    context 'false' do
      let(:params) {{
        :use_mirror => false,
      }}

      it { is_expected.to contain_apt__ppa('ppa:gds/govuk') }
    end
  end
end
