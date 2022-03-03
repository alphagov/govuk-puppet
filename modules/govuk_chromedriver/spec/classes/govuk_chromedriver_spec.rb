require_relative '../../../../spec_helper'

describe 'govuk_chromedriver', :type => :class do

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class('govuk_chromedriver') }

  it { is_expected.to contain_file('/usr/sbin/install-chromedriver').with_ensure('file') }

  it { is_expected.to contain_exec('install-chromedriver') }
end
