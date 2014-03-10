require_relative '../../../../spec_helper'

describe 'nginx::log', :type => :define do
  context 'absolute filename as title' do
    let(:title) { '/var/log/nginx/caterpillar.log' }
    it { expect { should }.to raise_error(Puppet::Error, /validate_re/) }
  end

  context 'with ensure' do
    let(:title) { 'rabbit' }

    context 'absent' do
      let(:params) {{ :ensure => 'absent' }}

      it do
        expect { should contain_file('/var/log/nginx/rabbit').with_ensure('absent') }
      end
    end

    context 'true' do
      let(:params) {{ :ensure => 'true' }}

      it { expect { should }.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end

    context 'false' do
      let(:params) {{ :ensure => 'false' }}
      
      it { expect { should }.to raise_error(Puppet::Error, /Invalid ensure value/) }
    end
  end
end
