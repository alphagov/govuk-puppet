require_relative '../../../../spec_helper'

describe 'icinga::check::graphite', :type => :define do
  before { update_extdata({ 'monitoring_domain_suffix' => 'monitoring.zoo.tld' }) }

  let(:facts) {{ :fqdn => 'warden.zoo.tld' }}
  let(:pre_condition) { 'icinga::host { "warden.zoo.tld": }' }

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
      should contain_icinga__check('count_tigers').with(
        :check_command              => 'check_graphite_metric_args!sumSeries(zoo.*.tiger)!10!20!-F 5minutes ',
        :service_description        => 'number of animals in the zoo',
        :host_name                  => 'warden.zoo.tld',
        :action_url                 => /^https:\/\/graphite\.monitoring\.zoo\.tld\/render\/\?width=\d+&height=\d+&target=sumSeries\(zoo\.\*\.tiger\)&target=alias\(dashed\(constantLine\(10\)\),%22warning%22\)&target=alias\(dashed\(constantLine\(20\)\),%22critical%22\)$/,
        :attempts_before_hard_state => 1,
      )
    end
  end

  context 'when passing target which includes double quotes' do
    let(:title) { 'count_tigers' }
    let(:params) {{
      :target    => 'summarize(zoo.*.tiger,"5minutes","max",true)',
      :desc      => 'maximum number of animals during each 5 minute period',
      :warning   => 10,
      :critical  => 20,
      :host_name => 'warden.zoo.tld',
    }}

    it 'should contain a nagios_check resource' do
      should contain_icinga__check('count_tigers').with(
        :check_command              => 'check_graphite_metric_args!summarize(zoo.*.tiger,"5minutes","max",true)!10!20!-F 5minutes ',
        :action_url                 => /^https:\/\/graphite\.monitoring\.zoo\.tld\/render\/\?width=\d+&height=\d+&target=summarize\(zoo\.\*\.tiger,%225minutes%22,%22max%22,true\)&target=alias\(dashed\(constantLine\(10\)\),%22warning%22\)&target=alias\(dashed\(constantLine\(20\)\),%22critical%22\)$/,
      )
    end
  end

  context 'when from and args params are passed' do
    let(:title) { 'count_deer' }
    let(:params) {{
      :target    => 'sumSeries(zoo.*.deer)',
      :desc      => 'number of meals in the zoo',
      :warning   => 30,
      :critical  => 40,
      :host_name => 'warden.zoo.tld',
      :from      => '23minutes',
      :args      => '--droplast 1',
    }}

    it 'should modify check_command' do
      should contain_icinga__check('count_deer').with(
        :check_command => 'check_graphite_metric_args!sumSeries(zoo.*.deer)!30!40!-F 23minutes --droplast 1',
      )
    end
  end
end
