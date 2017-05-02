require_relative '../../../../spec_helper'

describe 'govuk_docker::logspout', :type => :class do
  let(:pre_condition) { 'include ::docker' }

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }


  context {
    let(:params){{ :endpoint => 'example.com' }}
    it {
      is_expected.to contain_docker__image('govuk/logspout-alpine').with(
        'ensure'    => 'present',
        'image_tag' => 'latest',
      )

      is_expected.to contain_docker__run('logspout').with(
        'image'   => 'govuk/logspout-alpine:latest',
        'env'     => ['LOGSTASH_TAGS=docker,json_log'],
        'volumes' => ['/var/run/docker.sock:/var/run/docker.sock'],
        'command' => 'logstash+tls://example.com',
        'require' => 'Docker::Image[govuk/logspout-alpine]',
      )
    }
  }

end
