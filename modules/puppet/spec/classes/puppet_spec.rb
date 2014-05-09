require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  let (:hiera_data) {{
    :app_domain => 'giraffe.example.com',
  }}

  context 'with $use_puppetmaster = false' do
    let (:params) {{
      :use_puppetmaster => false,
    }}

    it do
      should contain_file('/etc/puppet/puppet.conf').with_content(/manifestdir = \/var\/govuk\/puppet\/manifests/)
      should contain_file('/usr/local/bin/govuk_puppet').with_source('puppet:///modules/puppet/govuk_puppet_development')
    end
  end

  context 'with $use_puppetmaster = true' do
    let (:params) {{
      :use_puppetmaster => true,
    }}

    it do
      should contain_file('/etc/puppet/puppet.conf').with_content(/manifestdir = \/usr\/share\/puppet\/production\/current\/manifests/)
      should contain_file('/usr/local/bin/govuk_puppet').with_source('puppet:///modules/puppet/govuk_puppet')
    end
  end
end
