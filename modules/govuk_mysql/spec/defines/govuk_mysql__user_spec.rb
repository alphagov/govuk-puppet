require_relative '../../../../spec_helper'

describe 'govuk_mysql::user', :type => :define do
  context 'valid name' do
    let(:title) { 'root@localhost' }

    context 'valid params' do
      let(:params) {{
        :password_hash => 'abc',
        :table         => '*.*',
        :privileges    => ['SELECT'],
      }}

      it {
        should contain_mysql_user('root@localhost').with(
          :ensure        => 'present',
          :password_hash => 'abc'
        )
      }
      it {
        should contain_mysql_grant('root@localhost/*.*').with(
          :ensure     => 'present',
          :user       => 'root@localhost',
          :table      => '*.*',
          :privileges => ['SELECT'],
        )
      }
    end

    context 'ensure absent' do
      let(:params) {{
        :ensure        => 'absent',
        :password_hash => 'abc',
        :table         => '*.*',
        :privileges    => ['SELECT'],
      }}

      it { should contain_mysql_user('root@localhost').with_ensure('absent') }
      it { should contain_mysql_grant('root@localhost/*.*').with_ensure('absent') }
    end
  end

  context 'name invalid' do
    let(:params) {{
      :password_hash => 'abc',
      :table         => '*.*',
      :privileges    => ['SELECT'],
    }}

    context 'does not contain host' do
      let(:title) { 'root' }

      it { expect { should }.to raise_error(Puppet::Error, /validate_re/) }
    end

    context 'contains table' do
      let(:title) { 'root@localhost/*.*' }

      it { expect { should }.to raise_error(Puppet::Error, /validate_re/) }
    end
  end
end
