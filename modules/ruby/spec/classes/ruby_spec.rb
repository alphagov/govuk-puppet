require_relative '../../../../spec_helper'

describe 'ruby', :type => :class do
  let(:params) { {'version' => '1.2.3.4.5.6'} }
  it do
    should contain_package('ruby1.9.1').with({'ensure'  => '1.2.3.4.5.6'})
    should contain_package('ruby1.9.1-dev').with({'ensure'  => '1.2.3.4.5.6'})
  end
end
