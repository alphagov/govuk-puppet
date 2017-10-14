require_relative '../../../../spec_helper'

describe 'govuk_containers::cluster::app', :type => :define do
  let(:title) { 'bella' }

  let :default_params do
    {
      :port    => '1234',
      :envvars => { 'furry' => 'socks' },
    }
  end

  context 'with some envvars set' do
    let(:params) { default_params }

    it do
      is_expected.to contain_file('/etc/govuk/bella/env.d').with(
        :ensure => 'directory',
      )

      is_expected.to contain_govuk_containers__envvar('bella').with(
        :ensure    => 'present',
        :directory => '/etc/govuk/bella/env.d',
        :envvars   => { 'furry' => 'socks' },
      )

      is_expected.to contain_nginx__config__vhost__proxy('bella.environment.example.com').with(
        :ensure  => 'present',
        :to      => ['localhost:1234'],
        :aliases => [],
      )
    end
  end
end
