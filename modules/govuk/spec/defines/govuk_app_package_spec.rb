require_relative '../../../../spec_helper'

describe 'govuk::app::package', :type => :define do
  let(:title) { 'giraffe' }

  context 'with no params' do
    it do
      expect {
        should contain_file('/var/apps/giraffe')
      }.to raise_error(Puppet::Error, /Must pass vhost_full/)
    end
  end

  context 'with good params' do
    let(:params) do
      {
        :vhost_full => 'giraffe.example.com',
      }
    end

    it do
      should contain_file('/var/apps/giraffe').with_ensure('link')
      should contain_file('/var/log/giraffe')
      should contain_file('/data/vhost/giraffe.example.com')
    end
  end

  context 'ensure' do
    context 'absent' do
      let(:params) do
        {
          :vhost_full => 'giraffe.example.com',
          :ensure     => 'absent',
        }
      end

      it do
        should contain_file('/var/apps/giraffe').with_ensure('absent')
        should contain_file('/var/log/giraffe').with_ensure('absent')
        should contain_file('/data/vhost/giraffe.example.com').with_ensure('absent')
      end
    end

    context 'invalid' do
      let(:params) do
        {
          :vhost_full => 'giraffe.example.com',
          :ensure     => 'invalid',
        }
      end

      it do
        expect {
          should contain_file('/var/apps/giraffe')
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
  end
end
