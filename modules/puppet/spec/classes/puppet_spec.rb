require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it { should contain_file('/etc/puppet/puppet.conf') }
  it { should contain_package("puppet").with_provider('gem') }
end
