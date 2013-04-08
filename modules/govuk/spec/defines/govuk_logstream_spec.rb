require_relative '../../../../spec_helper'

describe 'govuk::logstream', :type => :define do
  let(:title) { 'giraffe' }

  context 'with vanilla enable true' do
    let(:params) { {
      :logfile => '/var/log/elephant.log',
      :enable => true,
    } }

    it {
      should contain_file('/etc/init/logstream-giraffe.conf').with(
        :content => /^\s+tail -F \/var\/log\/elephant\.log \| govuk_logpipe/
      )
    }

    it {
      should_not contain_file('/etc/init/logstream-giraffe.conf').with(
        :content => /--json/
      )
    }
  end

  context 'with json' do
    let(:params) { {
      :logfile => '/var/log/elephant.log',
      :enable => true,
      :json => true,
    } }

    it {
      should contain_file('/etc/init/logstream-giraffe.conf').with(
        :content => /--json /
      )
    }
  end

end
