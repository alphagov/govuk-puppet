require_relative '../../../../spec_helper'

describe "collectd::plugin::cdn_fastly", :type => :class do
  let(:pre_condition) { 'Collectd::Plugin <||>' }
  let(:params) {{
    :username => 'Patrica',
    :password => 'drowssap',
    :services => {
      'test' => 1,
      'another_val' => 'some string',
    },
  }}

  it 'Includes the correct resources' do
    is_expected.to contain_package('collectd-cdn')
    is_expected.to contain_class('Collectd::Plugin::Python')
  end

  it 'Correctly sets the Service attributes' do
    is_expected.to contain_collectd__plugin("cdn_fastly").with_content(<<-EOS
<LoadPlugin python>
  Globals true
</LoadPlugin>

<Plugin python>
  Import "collectd_cdn.fastly"

  <Module "collectd_cdn.fastly">
    ApiUser "Patrica"
    ApiPass "drowssap"

    <Service>
      Name "test"
      Id "1"
    </Service>
    <Service>
      Name "another_val"
      Id "some string"
    </Service>
  </Module>
</Plugin>
EOS
    )
  end
end
