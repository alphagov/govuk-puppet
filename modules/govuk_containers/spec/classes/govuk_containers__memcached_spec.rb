require_relative '../../../../spec_helper'

describe 'govuk_containers::memcached', :type => :class do
  let(:pre_condition) { 'include ::govuk_docker' }
  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }
end
