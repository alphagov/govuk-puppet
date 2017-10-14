require_relative '../../../../spec_helper'

describe 'govuk_docker::swarm', :type => :define do
  let(:title) { 'bella' }
  let(:facts) {{ :hostname => 'dockerhost' }}

  context 'as a manager' do
    let(:params) {{
      :role => 'manager',
      }}
    it { is_expected.to contain_file('/usr/local/bin/swarm_manager') }
    it { is_expected.to contain_cron__crondotdee('docker_swarm_manager_dockerhost').with(
      :command => '/usr/local/bin/swarm_manager default_cluster',
    ) }
  end
  context 'as a worker' do
    let(:params) {{
      :role => 'worker',
      }}
    it { is_expected.to contain_file('/usr/local/bin/swarm_worker') }
    it { is_expected.to contain_cron__crondotdee('docker_swarm_worker_dockerhost').with(
      :command => '/usr/local/bin/swarm_worker default_cluster',
    ) }
  end
end
