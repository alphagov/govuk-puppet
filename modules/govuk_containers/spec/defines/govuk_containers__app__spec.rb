require_relative '../../../../spec_helper'

describe 'govuk_containers::app', :type => :define do
  let(:title) { 'bella' }

  let :default_params do
    {
      :image => 'cat',
      :image_tag => 'v1',
      :port => '1234',
    }
  end

  context 'with minimum params' do
    let(:params) { default_params }

    it do
      is_expected.to contain_docker__image('cat').with(
        'ensure' => 'present',
        'image_tag' => 'v1',
      )
      is_expected.to contain_docker__run('bella').with(
        'image' => 'cat:v1',
        'ports' => '1234:1234',
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
        'image' => 'cat:v1',
        'ports' => '1234:1234',
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
        'image' => 'cat:v1',
        'ports' => '1234:1234',
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
        'image' => 'cat:v1',
        'ports' => '1234:1234',
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
