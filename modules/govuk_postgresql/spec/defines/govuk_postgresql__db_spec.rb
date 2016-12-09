require_relative '../../../../spec_helper'

describe 'govuk_postgresql::db', :type => :define do
    let(:title) { 'giraffe' }
    let(:facts) {{
        :concat_basedir => '/tmp/concat',
    }}
    let(:pre_condition) { <<-EOS
      include govuk_postgresql::server::standalone
      EOS
    }

    context 'minimum info' do
        let(:params) {{
          :user     => 'monkey',
          :password => 'gibbon'
        }}
        it {
            is_expected.to contain_postgresql__server__db('giraffe').with(
                :user     => 'monkey',
                :encoding => 'UTF8',
                :owner    => 'monkey',
                :password => 'md54b965058299a9d34979e4e88b0909678',
            )
        }
        it {
            is_expected.not_to contain_postgresql__server__pg_hba_rule(
                "Allow access for monkey role to giraffe database from backend network"
            )
        }
    end

    context 'set an owner' do
        let(:params) {{
          :user     => 'monkey',
          :password => 'gibbon',
          :owner    => 'vole'
        }}
        it {
            is_expected.to contain_postgresql__server__db('giraffe').with(
                :user     => 'monkey',
                :owner    => 'vole',
            )
        }
    end

    context 'change encoding' do
        let(:params) {{
          :user     => 'monkey',
          :password => 'gibbon',
          :encoding => 'ROT13'
        }}
        it {
            is_expected.to contain_postgresql__server__db('giraffe').with(
                :encoding     => 'ROT13',
            )
        }
    end

    context 'create pg_hba.conf rule allowing authentication from backend network' do
        let(:params) {{
          :user                    => 'monkey',
          :password                => 'gibbon',
          :allow_auth_from_backend => true,
          :backend_ip_range        => '10.0.0.0/8',
        }}
        it {
            is_expected.to contain_postgresql__server__pg_hba_rule(
                'Allow access for monkey role to giraffe database from backend network'
            ).with_type('host')
        }
    end

    context 'create ssl only pg_hba.conf rule allowing authentication from backend network' do
        let(:params) {{
          :user                    => 'monkey',
          :password                => 'gibbon',
          :allow_auth_from_backend => true,
          :backend_ip_range        => '10.0.0.0/8',
          :ssl_only                => true,
        }}
        it {
            is_expected.to contain_postgresql__server__pg_hba_rule(
                'Allow access for monkey role to giraffe database from backend network'
            ).with_type('hostssl')
        }
    end

end

