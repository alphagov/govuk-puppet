require_relative '../../../../spec_helper'

describe 'icinga::check::graphite', :type => :define do

  let(:facts) {{
    :fqdn       => 'warden.zoo.tld',
    :fqdn_short => 'warden.zoo',
    :ipaddress  => '10.10.10.10',
  }}

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
      is_expected.to contain_icinga__check('count_tigers').with(
        :check_command              => 'check_graphite_metric_args!sumSeries(zoo.*.tiger)!10!20!-F 5minutes ',
        :service_description        => 'number of animals in the zoo',
        :host_name                  => 'warden.zoo.tld',
        :action_url                 => /^https:\/\/graphite\.environment\.example\.com\/render\/\?width=\d+&height=\d+&colorList=[a-z,]+&target=alias\(dashed\(constantLine\(20\)\),%22critical%22\)&target=alias\(dashed\(constantLine\(10\)\),%22warning%22\)&target=sumSeries\(zoo\.\*\.tiger\)$/,
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
      is_expected.to contain_icinga__check('count_tigers').with(
        :check_command              => 'check_graphite_metric_args!summarize(zoo.*.tiger,"5minutes","max",true)!10!20!-F 5minutes ',
        :action_url                 => /^https:\/\/graphite\.environment\.example\.com\/render\/\?width=\d+&height=\d+&colorList=[a-z,]+&target=alias\(dashed\(constantLine\(20\)\),%22critical%22\)&target=alias\(dashed\(constantLine\(10\)\),%22warning%22\)&target=summarize\(zoo\.\*\.tiger,%225minutes%22,%22max%22,true\)$/,
      )
    end
  end

  context 'when warning is NaN and critical is a float' do
    let(:title) { 'count_tigers' }
    let(:params) {{
      :target    => 'sumSeries(zoo.*.tiger)',
      :desc      => 'number of animals in the zoo',
      :warning   => '10:20',
      :critical  => '10.20',
      :host_name => 'warden.zoo.tld',
    }}

    it 'should not contain warning line but should contain critical line in linked graph' do
      is_expected.to contain_icinga__check('count_tigers').with(
        :check_command => 'check_graphite_metric_args!sumSeries(zoo.*.tiger)!10:20!10.20!-F 5minutes ',
        :action_url    => /^https:\/\/graphite\.environment\.example\.com\/render\/\?width=\d+&height=\d+&colorList=[a-z,]+&target=alias\(dashed\(constantLine\(10.20\)\),%22critical%22\)&target=sumSeries\(zoo\.\*\.tiger\)$/,
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
      is_expected.to contain_icinga__check('count_deer').with(
        :check_command => 'check_graphite_metric_args!sumSeries(zoo.*.deer)!30!40!-F 23minutes --droplast 1',
      )
    end
  end

  context 'when passing inverse crit/warn are passed' do
    let(:title) { 'count_inverse_deer' }
     let(:params) {{
      :target    => 'sumSeries(zoo.*.deer)',
      :desc      => 'number of meals in the zoo',
      :warning   => '@30',
      :critical  => '@40',
      :host_name => 'warden.zoo.tld',
      :from      => '23minutes',
      :args      => '--droplast 1',
    }}

    it 'should modify check_command' do
      is_expected.to contain_icinga__check('count_inverse_deer').with(
        :check_command => 'check_graphite_metric_args!sumSeries(zoo.*.deer)!@30!@40!-F 23minutes --droplast 1',
      )
    end
  end

  context 'when ensure is passed' do
    context 'ensure => absent' do
      let(:title) { 'count_nothing' }
      let(:params) {{
        :target    => 'sumSeries(zoo.*.nothing)',
        :desc      => 'number of meals in the zoo',
        :warning   => 30,
        :critical  => 40,
        :host_name => 'warden.zoo.tld',
        :from      => '23minutes',
        :args      => '--droplast 1',
        :ensure    => 'absent',
      }}

      it do
        is_expected.to contain_icinga__check('count_nothing').with_ensure('absent')
      end
    end

    context 'ensure => false' do
      let(:title) { 'count_nothing' }
      let(:params) {{
        :target    => 'sumSeries(zoo.*.nothing)',
        :desc      => 'number of meals in the zoo',
        :warning   => 30,
        :critical  => 40,
        :host_name => 'warden.zoo.tld',
        :from      => '23minutes',
        :args      => '--droplast 1',
        :ensure    => 'false',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end
    
    context 'ensure => true' do
      let(:title) { 'count_nothing' }
      let(:params) {{
        :target    => 'sumSeries(zoo.*.nothing)',
        :desc      => 'number of meals in the zoo',
        :warning   => 30,
        :critical  => 40,
        :host_name => 'warden.zoo.tld',
        :from      => '23minutes',
        :args      => '--droplast 1',
        :ensure    => 'true',
      }}

      it { is_expected.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end
  end
end
