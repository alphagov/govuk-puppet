require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  it do
    should contain_package('nginx')
  end
end
