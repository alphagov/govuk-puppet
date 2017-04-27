require_relative '../../../../spec_helper'

describe "collectd::plugin::python", :type => :class do
  let(:pre_condition) { 'File <||> Collectd::Plugin <||>' }

  it 'Includes the correct resources' do
    is_expected.to contain_file('/usr/lib/collectd/python').with_ensure('directory')
    is_expected.to contain_file('/usr/lib/collectd/python/__init__.py').with_content('')
    is_expected.to contain_file('/etc/collectd/conf.d/00-python.conf')
    is_expected.to contain_collectd__plugin('00-python')
  end
end
