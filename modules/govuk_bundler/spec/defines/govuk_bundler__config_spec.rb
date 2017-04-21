require_relative '../../../../spec_helper'

describe 'govuk_bundler::config', :type => :define do
  let(:title) { 'bundler-test' }

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_file('/home/deploy/.bundle').with_ensure('directory') }

  it { is_expected.to contain_file('/home/deploy/.bundle/config').with_content(/BUNDLE_MIRROR__HTTPS:\/\/RUBYGEMS\.ORG: http:\/\/gemstash\.cluster\//) }

  context 'with non-default params' do
    let(:params) { {
      :user_home => '/why/not/here',
      :server => 'http://www.example.com:4224',
    } }
    it { is_expected.to contain_file('/why/not/here/.bundle/config').with_content(/BUNDLE_MIRROR__HTTPS:\/\/RUBYGEMS\.ORG: http:\/\/www\.example\.com:4224\//) }
  end
end
