require_relative '../../../../spec_helper'

describe 'govuk_env_sync::sync_script', :type => :class do

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

end
