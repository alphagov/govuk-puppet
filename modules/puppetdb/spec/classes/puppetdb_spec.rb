require_relative '../../../../spec_helper'

describe 'puppetdb', :type => :class do
  let (:facts) {{
    :lsbdistcodename => 'Precise',
  }}
  let (:params) {{ :package_ensure => '1.2.3' }}
  it { should contain_package('puppetdb').with_ensure('1.2.3') }
end
