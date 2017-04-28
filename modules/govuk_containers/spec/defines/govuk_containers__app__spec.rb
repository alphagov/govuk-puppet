require_relative '../../../../spec_helper'

describe 'govuk_containers::app', :type => :define do
  let(:title) { 'bella' }

  let :default_params do
    {
      :image => 'cat',
      :port => '1234',
      :global_env_file => '/etc/global.env',
    }
  end

  context 'with minimum params' do
    let(:params) { default_params }

    it do
      is_expected.to contain_docker__run('bella').with(
        'net' => 'host',
        'image' => 'cat:current',
        'ports' => '1234:1234',
        'env_file' => '/etc/global.env',
        'extra_parameters' => '--restart=on-failure:3',
      )
    end
  end

  context 'setting environment variables' do
    let(:params) do
      {
        :envvars => [ 'cheese=milk', 'wheat=bread' ],
      }.merge(default_params)
    end

    it do
      is_expected.to contain_docker__run('bella').with(
        'net' => 'host',
        'image' => 'cat:current',
        'ports' => '1234:1234',
        'env_file' => '/etc/global.env',
        'env' => [ 'cheese=milk', 'wheat=bread' ],
        'extra_parameters' => '--restart=on-failure:3',
      )
    end
  end

  context 'setting restart_attempts to "never"' do
    let(:params) do
      {
        :restart_attempts => 'never',
      }.merge(default_params)
    end

    it do
      is_expected.to contain_docker__run('bella').with(
        'net' => 'host',
        'image' => 'cat:current',
        'ports' => '1234:1234',
        'env_file' => '/etc/global.env',
        'extra_parameters' => '--restart=no',
      )
    end
  end

  context 'setting restart_attempts to "always"' do
    let(:params) do
      {
        :restart_attempts => 'always',
      }.merge(default_params)
    end

    it do
      is_expected.to contain_docker__run('bella').with(
        'net' => 'host',
        'image' => 'cat:current',
        'ports' => '1234:1234',
        'env_file' => '/etc/global.env',
        'extra_parameters' => '--restart=always',
      )
    end
  end

  context 'setting restart_attempts to something other than "always", "never" or a number' do
    let(:params) do
      {
        :restart_attempts => 'foo',
      }.merge(default_params)
    end

    it { is_expected.to raise_error(Puppet::Error, /validate_re/) }
  end
end
