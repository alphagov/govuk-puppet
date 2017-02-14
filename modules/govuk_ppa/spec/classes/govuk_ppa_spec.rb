require_relative '../../../../spec_helper'

describe 'govuk_ppa', :type => :class do
  let (:facts) {{
    :lsbdistcode    => 'trusty',
    :lsbdistid      => 'Ubuntu',
    :lsbdistrelease => '14.04',
  }}
  describe '#path' do
    context 'production (default)' do

      it { is_expected.to contain_apt__source('govuk-ppa').with_location('http://apt_mirror.cluster/govuk/ppa/production') }
    end

    context 'another environment' do
      let(:params) {{
        :path => 'another-environment',
      }}

      it { is_expected.to contain_apt__source('govuk-ppa').with_location('http://apt_mirror.cluster/govuk/ppa/another-environment') }
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
