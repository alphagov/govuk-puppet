require_relative '../../../../spec_helper'

shared_examples 'cron splay' do |fqdn|
  it 'should set cron.hourly to **:01-**:15' do
    should contain_file('/etc/crontab').with_content(/^([1-9]|1[0-5])\s+\*\s+.*cron\.hourly$/)
  end
  it 'should set cron.daily to 06:11-06:25' do
    should contain_file('/etc/crontab').with_content(/^(1[1-9]|2[0-5])\s+6\s+.*cron\.daily \)$/)
  end
  it 'should set cron.weekly to 06:26-06:40' do
    should contain_file('/etc/crontab').with_content(/^(2[6-9]|3[0-9]|40)\s+6\s+.*cron\.weekly \)$/)
  end
  it 'should set cron.monthly to 06:41-06:55' do
    should contain_file('/etc/crontab').with_content(/^(4[1-9]|5[0-5])\s+6\s+.*cron\.monthly \)$/)
  end
end

describe 'cron', :type => :class do
  it { should contain_service('cron').with_ensure('running') }
  it { should contain_file('/etc/default/cron').with_source('puppet:///modules/cron/etc/default/cron') }

  %w{some arbitrary strings}.each do |fqdn|
    context "fqdn_rand with '#{fqdn}'" do
      let(:node) { fqdn }
      it_should_behave_like 'cron splay', fqdn
    end
  end
end
