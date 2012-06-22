require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  it { should contain_package('nginx').with({
      'ensure'  => 'installed'
  })}

end
