require_relative '../../../../spec_helper'

describe 'govuk_puppetdb', :type => :class do
  # concat_basedir needed for postgresql module
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat/'}}
  let (:params) {{ :package_ensure => '1.2.3' }}
  it { is_expected.to contain_package('puppetdb').with_ensure('1.2.3') }
end
