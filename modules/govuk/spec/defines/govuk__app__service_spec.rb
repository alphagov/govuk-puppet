require_relative '../../../../spec_helper'

describe 'govuk::app::service', :type => :define do
  context 'when title is mysvc' do
    let(:title) { 'mysvc' }

    context 'when services are disabled' do
      it { is_expected.to compile }

      it do
        is_expected.to contain_service('mysvc').with(
          :ensure => 'stopped',
          :provider => 'upstart',
        )
      end
    end

    context 'when services are enabled' do
      let(:hiera_config) do
        { 'govuk_app_enable_services' => true }
      end

      context 'with no params' do
        let(:params) { {} }

        it { is_expected.to compile }

        it do
          is_expected.to contain_service('mysvc').with(
            :ensure => 'running',
            :provider => 'upstart',
            :hasrestart => false,
            :restart => nil,
          )
        end
      end

      context 'with hasrestart override' do
        let(:params) do
          {
            :hasrestart => true,
          }
        end

        it { is_expected.to compile }

        it do
          is_expected.to contain_service('mysvc').with(
            :ensure => 'running',
            :provider => 'upstart',
            :hasrestart => true,
            :restart => nil,
          )
        end
      end

      context 'with restart override' do
        let(:params) do
          {
            :restart => 'command-to-run-instead-of service mysvc restart',
          }
        end

        it { is_expected.to compile }

        it do
          is_expected.to contain_service('mysvc').with(
            :ensure => 'running',
            :provider => 'upstart',
            :hasrestart => false,
            :restart => 'command-to-run-instead-of service mysvc restart',
          )
        end
      end
    end
  end
end
