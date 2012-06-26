require_relative '../../../../spec_helper'

describe 'ruby::rubygems', :type => :class do
  let(:params) { {'version' => '1.2.3.4.5.6'} }
  it { should contain_exec('rubygems-1.2.3.4.5.6').with({
      'command' => 'gem install rubygems-update -v 1.2.3.4.5.6 && update_rubygems _1.2.3.4.5.6_',
      'unless' => "gem -v | grep -q '^1.2.3.4.5.6$'",
      'logoutput' => 'on_failure'
  })}
end
