require_relative '../../../../spec_helper'

describe 'govuk_containers::frontend::haproxy', :type => :class do
  let(:pre_condition) {'include ::govuk_docker'}
  let(:params) { {
      :backend_mappings                => [ { "release.dev.gov.uk" => "release" } ],
    }}
  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }
end
