require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  it do
    is_expected.to contain_package('nginx').with_ensure('1.14.0-1~trusty')
    is_expected.to contain_package('nginx-module-perl').with_ensure('present')
  end
end
