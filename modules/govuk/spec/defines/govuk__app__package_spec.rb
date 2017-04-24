require_relative '../../../../spec_helper'

describe 'govuk::app::package', :type => :define do
  let(:title) { 'giraffe' }

  context 'with no params' do
    it do
      expect {
        is_expected.to contain_file('/var/apps/giraffe')
      }.to raise_error(Puppet::Error, /Must pass vhost_full/)
    end
  end

  context 'with good params' do
    let(:params) do
      {
        :vhost_full => 'giraffe.example.com',
        :repo_name => 'elephant',
      }
    end

    it do
      is_expected.to contain_file('/var/apps/giraffe').with_ensure('link')
      is_expected.to contain_file('/var/log/giraffe')
      is_expected.to contain_file('/data/vhost/giraffe.example.com')
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
        is_expected.to contain_file('/var/apps/giraffe').with_ensure('absent')
        is_expected.to contain_file('/var/log/giraffe').with_ensure('absent')
        is_expected.to contain_file('/data/vhost/giraffe.example.com').with_ensure('absent')
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
          is_expected.to contain_file('/var/apps/giraffe')
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
  end
end
