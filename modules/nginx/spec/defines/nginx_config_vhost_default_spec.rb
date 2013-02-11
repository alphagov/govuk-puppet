require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::default', :type => :define do
  let(:title) { 'donkey' }

  context 'with no params' do
    it 'should install a default vhost that 500s' do
      should contain_nginx__config__site('donkey')
        .with_content(/listen.*\s+default_server;/)
        .with_content(/return\s+500/)
        .with_content(/location = \/healthcheck \{/)
    end
  end

  context 'with a specified status code' do
    let(:params) do
      { :status => '418' }
    end
    it 'should install a default vhost that returns that status code' do
      should contain_nginx__config__site('donkey')
        .with_content(/listen.*\s+default_server;/)
        .with_content(/return\s+418/)
    end
  end

  context 'with healthcheck disabled' do
    let(:params) do
      { :healthcheck => false }
    end
    it { should_not contain_nginx__config__site('donkey')
      .with_content(/location = \/healthcheck \{/)
    }
  end

  context 'with healthcheck /giraffe' do
    let(:params) do
      { :healthcheck => '/giraffe' }
    end
    it { should contain_nginx__config__site('donkey')
      .with_content( /location = \/giraffe \{/)
    }
  end
end
