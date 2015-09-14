require_relative '../../../../spec_helper'

shared_examples 'cron splay' do |fqdn|
  it 'should set cron.hourly to **:01-**:15' do
    is_expected.to contain_file('/etc/crontab').with_content(/^([1-9]|1[0-5])\s+\*\s+.*cron\.hourly$/)
  end
  it 'should set cron.daily to 05:01-05:59' do
    is_expected.to contain_file('/etc/crontab').with_content(/^([0-9]|[1-5][0-9])\s+5\s+.*cron\.daily \)$/)
  end
  it 'should set cron.weekly to 06:26-06:40' do
    is_expected.to contain_file('/etc/crontab').with_content(/^(2[6-9]|3[0-9]|40)\s+6\s+.*cron\.weekly \)$/)
  end
  it 'should set cron.monthly to 06:41-06:55' do
    is_expected.to contain_file('/etc/crontab').with_content(/^(4[1-9]|5[0-5])\s+6\s+.*cron\.monthly \)$/)
  end
end

describe 'cron', :type => :class do
  it { is_expected.to contain_service('cron').with_ensure('running') }
  it { is_expected.to contain_file('/etc/default/cron').with_source('puppet:///modules/cron/etc/default/cron') }

  %w{some arbitrary strings}.each do |fqdn|
    context "fqdn_rand with '#{fqdn}'" do
      let(:node) { fqdn }
      it_should_behave_like 'cron splay', fqdn
    end
  end

  describe "Setting cron.weekly day" do
    let(:params) {{}}

    it "defaults to 7 (sunday)" do
      expect(subject).to contain_file('/etc/crontab')
        .with_content(/^(\S+\s+){4}7\s.*cron\.weekly/)
    end

    it "can be overridden" do
      params[:weekly_dow] = 1
      expect(subject).to contain_file('/etc/crontab')
        .with_content(/^(\S+\s+){4}1\s.*cron\.weekly/)
    end

    it "raises an error with an invalid value" do
      params[:weekly_dow] = 8

      expect {
        subject
      }.to raise_error(Puppet::Error, /Expected 8 to be smaller or equal to 7/)

      params[:weekly_dow] = -1
      expect {
        subject
      }.to raise_error(Puppet::Error, /Expected -1 to be greater or equal to 0/)

      params[:weekly_dow] = "foo"
      expect {
        subject
      }.to raise_error(Puppet::Error, /Expected first argument to be an Integer/)
    end
  end
end
