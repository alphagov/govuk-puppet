require_relative '../../../../spec_helper'

describe 'govuk_docker', :type => :class do

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

  context 'default params' do
    it { is_expected.to contain_class('Govuk_docker::Logspout') }
  end

  context 'enable_logspout set to false' do
    let(:params) {{enable_logspout: false}}
    it { is_expected.not_to contain_class('Govuk_docker::Logspout') }
  end
end
