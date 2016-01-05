require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  context 'with $use_puppetmaster = false' do
    let (:params) {{
      :use_puppetmaster => false,
    }}

    it do
      is_expected.to contain_file('/etc/puppet/puppet.conf').with_content(/environmentpath = \/var\/govuk\/govuk-puppet\/environments/)
      is_expected.to contain_file('/usr/local/bin/govuk_puppet').with_content(/puppet-apply-dev/)
    end
  end

  context 'with $use_puppetmaster = true' do
    let (:params) {{
      :use_puppetmaster => true,
    }}

    it do
      is_expected.to contain_file('/etc/puppet/puppet.conf').with_content(/environmentpath = \/usr\/share\/puppet\/production\/current\/environments/)
      is_expected.to contain_file('/usr/local/bin/govuk_puppet').with_content(/puppet agent --onetime --no-daemonize/)
    end
  end
end
