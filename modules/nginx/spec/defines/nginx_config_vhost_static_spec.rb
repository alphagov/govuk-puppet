require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::static', :type => :define do
  let(:title) { 'static.example.com' }
  let(:pre_condition) { 'Logster::Cronjob <||>' }

  context 'with backend specified' do
    let(:params) do
      {
        :to => 'giraffe:1234',
      }
    end
    it 'should proxy to server giraffe:1234' do
      should contain_nginx__config__site('static.example.com').with_content(/server giraffe:1234/)
    end

    it { should contain_logster__cronjob('nginx-vhost-static.example.com')
      .with_prefix('nginx_logs.static_example_com') }
  end

  context 'with aliases' do
    let(:params) do
      {
        :to => 'giraffe:1234',
        :aliases => ['foo', 'bar'],
      }
    end

    it 'should proxy to server giraffe:1234' do
      should contain_nginx__config__site('static.example.com').with_content(/location \/foo\//)
      should contain_nginx__config__site('static.example.com').with_content(/alias \/data\/vhost\/foo\.test\.gov\.uk\/current\/public\/foo/)
      should contain_nginx__config__site('static.example.com').with_content(/location \/bar\//)
      should contain_nginx__config__site('static.example.com').with_content(/alias \/data\/vhost\/bar\.test\.gov\.uk\/current\/public\/bar/)
    end
  end
end
