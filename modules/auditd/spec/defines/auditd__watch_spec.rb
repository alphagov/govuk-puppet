require_relative '../../../../spec_helper'

describe 'auditd::watch', :type => :define do
  let(:title) { 'CFG_giraffe' }

  context 'with a given file' do
    let(:params) do
      { :file => '/etc/giraffe.conf' }
    end

    it 'should install an auditd watch rule' do
      should contain_concat__fragment('auditd-watch-CFG_giraffe')
        .with_target("/etc/audit/audit.rules")
        .with_content("-w /etc/giraffe.conf -k CFG_giraffe\n")
    end
  end
end
