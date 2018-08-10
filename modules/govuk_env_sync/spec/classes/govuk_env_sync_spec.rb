require_relative '../../../../spec_helper'

describe 'govuk_env_sync', :type => :class do
  it { is_expected.to compile }
  it { is_expected.to compile.with_all_deps }
end
