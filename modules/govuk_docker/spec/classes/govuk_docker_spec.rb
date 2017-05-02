require_relative '../../../../spec_helper'

describe 'govuk_docker', :type => :class do

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

  context 'it is integration' do
    let(:facts) {{domain: '.integration.publishing.service.gov.uk'}}
    it { is_expected.to contain_class('Govuk_docker::Logspout') }
  end

  context 'it is not in integration' do
    let(:facts) {{domain: 'anything.else'}}
    it { is_expected.not_to contain_class('Govuk_docker::Logspout') }
  end
end
