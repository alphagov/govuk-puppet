require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  it do
    is_expected.to contain_package('nginx').with_ensure('purged')
    is_expected.to contain_package('nginx-full').with_ensure('present')
  end
end
