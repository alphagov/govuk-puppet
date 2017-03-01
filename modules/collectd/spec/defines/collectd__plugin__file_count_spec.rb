require_relative '../../../../spec_helper'

describe "collectd::plugin::file_count", :type => :define do
  let(:pre_condition) { 'Collectd::Plugin <||>' }

  let(:title) { "some directory" }
  let(:directory) { "/some/directory" }
  let(:params) {{ :directory => directory }}

  it {
    is_expected.to contain_collectd__plugin("file count: #{title}").with_content(<<-EOS
LoadPlugin "filecount"
<Plugin "filecount">
  <Directory "#{directory}">
  </Directory>
</Plugin>
EOS
    )
  }
end
