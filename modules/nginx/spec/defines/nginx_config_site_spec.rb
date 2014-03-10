require_relative '../../../../spec_helper'

describe 'nginx::config::site', :type => :define do
  let(:title) { 'rabbit' }

  context 'empty' do
    let(:params) do
      {
      }
    end

    it do
      expect {
        should 
      }.to raise_error(Puppet::Error, /You must supply one of \$content or \$source/)
    end
  end

  context 'with ensure' do
    context 'absent' do
      let(:params) do
        {
          :content => 'stuff',
          :ensure => 'absent',
        }
      end

      it do
        should contain_file('/etc/nginx/sites-available/rabbit').with_ensure('absent')
      end
    end

    context 'true' do
      let(:params) do
        {
          :content => 'stuff',
          :ensure => 'true',
        }
      end

      it do
        expect {
          should
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
    
    context 'false' do
      let(:params) do
        {
          :content => 'stuff',
          :ensure => 'false',
        }
      end

      it do
        expect {
          should
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
  end

end
