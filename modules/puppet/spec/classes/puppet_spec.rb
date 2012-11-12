require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it do
    should contain_file('/etc/puppet/puppet.conf')
  end
end
