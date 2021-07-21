require_relative '../../../../spec_helper'

describe 'govuk_containers::gemstash', :type => :class do
  let(:pre_condition) { <<-EOS
    include ::govuk_python
    include ::govuk_docker
    EOS
  }
  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }
end
