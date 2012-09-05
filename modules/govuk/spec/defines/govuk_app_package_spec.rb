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
        :platform => 'production'
      }
    end

    it { should contain_file('/var/apps/giraffe').with_ensure('link') }
    it { should contain_file('/var/run/giraffe') }
    it { should contain_file('/var/log/giraffe') }
    it { should contain_file('/data/vhost/giraffe.example.com') }
  end
end
