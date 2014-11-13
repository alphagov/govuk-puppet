require_relative '../../../../spec_helper'

describe 'backup::offsite::job', :type => :define do
  let(:title) { 'caterpillar' }

  let(:default_params) {{
    :sources     => ['/pickle', '/salami'],
    :destination => 'rsync:///backup.example.com//lollipop',
    :hour        => 1,
    :minute      => 30,
    :gpg_key_id  => 'cupcake',
  }}

  context 'standard params' do
    let(:params) { default_params }

    it 'should include service description in NRPE command' do
      should contain_duplicity('caterpillar').with(
        :post_command => /\\toffsite backups: caterpillar\\t.*send_nsca/,
      )
    end
  end

  describe 'ensure' do
    context 'present (default)' do
      let(:params) { default_params }

      it {
        should contain_duplicity('caterpillar').with_ensure('present')
      }
    end

    context 'absent' do
      let(:params) { default_params.merge({
        :ensure => 'absent',
      })}

      it {
        should contain_duplicity('caterpillar').with_ensure('absent')
      }
    end

    context 'invalid' do
      let(:params) { default_params.merge({
        :ensure => 'invalid',
      })}

      it {
        expect { should }.to raise_error(Puppet::Error, /validate_re/)
      }
    end
  end
end
