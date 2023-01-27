require_relative '../../../../spec_helper'

describe 'govuk_containers::ci_redis', :type => :define do
  let(:title) { "ci-redis-instance" }

  let(:pre_condition) { <<-EOS
    include ::govuk_python
    include ::govuk_docker
    EOS
  }
  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }
end
