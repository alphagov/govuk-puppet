require_relative '../../../../spec_helper'

describe 'rubygems', :type => :class do
  let(:params) { {'version' => '1.2.3.4.5.6'} }
  it { should contain_exec('rubygems').with({
      'command' => '/usr/bin/gem update --system 1.2.3.4.5.6',
      'unless' => "/usr/bin/gem -v | /bin/grep -q '^1.2.3.4.5.6$'"
  })}
end
