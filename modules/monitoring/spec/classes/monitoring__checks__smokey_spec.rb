require_relative '../../../../spec_helper'

describe 'monitoring::checks::smokey', :type => :class do
  let(:pre_condition) {
    'icinga::host { "dummy.host": }'
  }
  let(:facts) {{
    :fqdn       => "dummy.host",
    :cache_bust => Time.now,
    :ipaddress  => '10.10.10.10',
    :fqdn_short => 'fakehost-1.management',
  }}

  context 'with disabled features' do
    let(:params) {{
      "features" => {
        "check_foo" => { "feature" => "foo" },
        "check_bar" => { "feature" => "bar", "enabled" => false },
      }
    }}

    it { is_expected.to contain_icinga__check("check_feature_foo_urgent_checker") }
    it { is_expected.not_to contain_icinga__check("check_feature_bar_urgent_checker") }
  end
end
