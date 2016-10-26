require_relative '../../../../spec_helper'

describe 'govuk_postgresql::server::standby', :type => :class do
  let(:param_host) { 'master.example.com' }
  let(:param_pass) { 'supersekret' }

  let(:pg_version) { '9.2' }
  let(:pg_user) { 'pg_user' }
  let(:pg_group) { 'pg_group' }

  let(:datadir) { "/var/lib/postgresql/#{pg_version}/main" }
  let(:recovery_conf) { "#{datadir}/recovery.tmp" }
  let(:pg_resync_slave) { '/usr/local/bin/pg_resync_slave' }

  let(:facts) {{
    :concat_basedir         => '/tmp/concat',
    :operatingsystem        => 'Ubuntu',
    :operatingsystemrelease => '14.04',
    :id                     => 'fake_id',
    :kernel                 => 'Linux',
  }}
  let(:params) {{
    :master_host     => param_host,
    :master_password => param_pass,
  }}
  let(:pre_condition) { <<-EOS
    class {
      'postgresql::globals':
        user    => #{pg_user},
        group   => #{pg_group},
        version => #{pg_version},
    }
    EOS
  }

  describe 'recovery.conf' do
    it 'should use $datadir, $user and $group from upstream postgres module' do
      is_expected.to contain_file(recovery_conf).with(
        :owner => pg_user,
        :group => pg_group,
      )
    end

    it 'should not be world readable' do
      is_expected.to contain_file(recovery_conf).with_mode('0600')
    end

    it 'should write details of master' do
      is_expected.to contain_file(recovery_conf).with_content(<<-EOS
standby_mode     = 'on'
primary_conninfo = 'host=#{param_host} user=replication password=#{param_pass}'
      EOS
      )
    end
  end

  describe 'pg_resync_slave' do
    it 'should reference $datadir' do
      is_expected.to contain_file(pg_resync_slave).with_content(/^DATADIR="#{datadir}"$/)
    end

    it 'should reference $user' do
      is_expected.to contain_file(pg_resync_slave).with_content(/^sudo -u #{pg_user} /)
    end

    it 'should reference host' do
      is_expected.to contain_file(pg_resync_slave).with_content(/ -h #{param_host} -U replication/)
    end
  end
end
