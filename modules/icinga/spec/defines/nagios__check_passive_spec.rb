require_relative '../../../../spec_helper'

describe 'icinga::passive_check', :type => :define do
  let(:title) { 'check_giraffes' }
  let(:file_path) { '/etc/icinga/conf.d/icinga_host_warden.zoo.tld/check_giraffes.cfg' }
  let(:facts) {{
    :fqdn => 'warden.zoo.tld',
  }}
  let(:pre_condition) {
    "icinga::host { 'warden.zoo.tld': }"
  }

  context 'mandatory params' do
    let(:params) {{
      :service_description => 'where are my giraffes',
      :host_name           => 'warden.zoo.tld',
    }}

    it {
      should contain_file(file_path)
        .with_content(/^\s+host_name\s+warden.zoo.tld$/)
    }
    it {
      should contain_file(file_path)
        .with_content(/^\s+service_description\s+where are my giraffes$/)
    }
    it {
      should contain_file(file_path)
        .with_content(/check_dummy!1!"Unexpected active check on passive service"$/)
    }
    it {
      should_not contain_file(file_path)
        .with_content(/freshness/)
    }
  end

  context 'freshness_threshold => 300' do
    let(:params) {{
      :service_description => 'where are my giraffes',
      :host_name           => 'warden.zoo.tld',
      :freshness_threshold => 300,
    }}

    it {
      should contain_file(file_path)
        .with_content(/check_dummy!1!"Freshness threshold exceeded"$/)
    }
    it {
      should contain_file(file_path)
        .with_content(/^\s+check_freshness\s+1\n\s+freshness_threshold\s+300$/)
    }
  end
end
