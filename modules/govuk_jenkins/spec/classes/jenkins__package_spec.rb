require_relative '../../../../spec_helper'

describe 'govuk_jenkins::package', :type => :class do
  let(:params) {{
    :apt_mirror_hostname => 'apt.example.com',
    :version             => '1.554.2',
  }}
  it { is_expected.to contain_class('jenkins').with(
    'version'            => '1.554.2',
    'repo'               => 'false',
    'install_java'       => 'false',
    'configure_firewall' => 'false',
  ) }
end
