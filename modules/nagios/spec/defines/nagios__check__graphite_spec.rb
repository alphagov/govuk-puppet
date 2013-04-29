require_relative '../../../../spec_helper'

describe 'nagios::check::graphite', :type => :define do
  before { update_extdata({ 'monitoring_domain_suffix' => 'monitoring.zoo.tld' }) }

  let(:facts) {{ :fqdn => 'warden.zoo.tld' }}
  let(:pre_condition) { 'nagios::host { "warden.zoo.tld": }' }

  context 'when required params are passed' do
    let(:title) { 'count_tigers' }
    let(:params) {{
      :target    => 'sumSeries(zoo.*.tiger)',
      :desc      => 'number of animals in the zoo',
      :warning   => 10,
      :critical  => 20,
      :host_name => 'warden.zoo.tld',
    }}

    it 'should contain a nagios_check resource' do
      should contain_nagios__check('count_tigers').with(
        :check_command              => 'check_graphite_metric_args!sumSeries(zoo.*.tiger)!10!20!-F 5minutes ',
        :service_description        => 'number of animals in the zoo',
        :host_name                  => 'warden.zoo.tld',
        :graph_url                  => /^https:\/\/graphite\.monitoring\.zoo\.tld\/render\/\?width=\d+&height=\d+&target=sumSeries\(zoo\.\*\.tiger\)&target=alias\(dashed\(constantLine\(10\)\),\"warning\"\)&target=alias\(dashed\(constantLine\(20\)\),\"critical\"\)$/,
        :attempts_before_hard_state => 1,
      )
    end
  end

  context 'when args are passed' do
    let(:title) { 'count_deer' }
    let(:params) {{
      :target    => 'sumSeries(zoo.*.deer)',
      :desc      => 'number of meals in the zoo',
      :warning   => 30,
      :critical  => 40,
      :host_name => 'warden.zoo.tld',
      :args      => '--droplast 1',
    }}

    it 'should modify check_command' do
      should contain_nagios__check('count_deer').with(
        :check_command => 'check_graphite_metric_args!sumSeries(zoo.*.deer)!30!40!-F 5minutes --droplast 1',
      )
    end
  end
end
