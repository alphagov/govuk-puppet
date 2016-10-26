require_relative '../../../../spec_helper'

describe 'govuk_postgresql::env_sync_user', :type => :class do
  let(:facts) {{
    :concat_basedir => '/tmp/concat',
    :id             => 'fake_id',
    :kernel         => 'Linux',
  }}
  let(:pre_condition) { <<-EOS
    include govuk_postgresql::server::standalone
    EOS
  }

  context 'creating the user and hba rule' do
    let(:params) {{
      "password" => "letmein",
    }}

    it {
      is_expected.to contain_postgresql__server__role('env-sync')
        .with_superuser(true)
    }

    it {
      # 'local env-sync' rule must be before the 'local all' rule because the rules are matched
      # in order, and the first match applies.
      is_expected.to contain_postgresql__server__pg_hba_rule('local access as env-sync user').with({
        "user" => 'env-sync',
        'type' => 'local',
        'order' => '001',
      })
      is_expected.to contain_postgresql__server__pg_hba_rule('local access to database with same name').with({
        'user' => 'all',
        'type' => 'local',
        'order' => '002',
      })
    }
  end

  context 'no password provided' do
    it {
      is_expected.to raise_error(
        Puppet::Error, /Must pass password to/
      )
    }
  end
end
