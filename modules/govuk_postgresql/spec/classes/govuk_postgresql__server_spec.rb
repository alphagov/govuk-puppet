require_relative '../../../../spec_helper'

describe 'govuk_postgresql::server', :type => :class do
  let(:facts) {{
    :concat_basedir => '/tmp/concat',
    :id             => 'fake_id',
    :kernel         => 'Linux',
  }}

  describe 'prevent direct use' do
    context 'standalone sub-class is loaded' do
      let(:pre_condition) { <<-EOS
        include govuk_postgresql::server::standalone
        EOS
      }

      it { is_expected.to contain_class('govuk_postgresql::server') }
    end

    context 'primary sub-class is loaded' do
      let(:pre_condition) { <<-EOS
        class { 'govuk_postgresql::server::primary':
          slave_password => 'password',
          slave_addresses  => {
            live => {
              address     => '0.0.0.0/0',
              auth_method => 'md5',
              database    => 'replication',
              'type'      => 'host',
              user        => 'replication',
            }
          }
        }
        EOS
      }

      it { is_expected.to contain_class('govuk_postgresql::server') }
    end

    context 'standby sub-class is loaded' do
      let(:pre_condition) { <<-EOS
        class { 'govuk_postgresql::server::standby':
          master_host     => '127.0.0.1',
          master_password => 'password',
        }
        EOS
      }

      it { is_expected.to contain_class('govuk_postgresql::server') }
    end

    context 'no sub-classes are loaded' do
      it {
        is_expected.to raise_error(
          Puppet::Error, /Class govuk_postgresql::server cannot be used directly/
        )
      }
    end
  end
end
