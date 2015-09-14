require_relative '../../../../spec_helper'

describe 'mapit::service', :type => :class do
  it { is_expected.to contain_service("mapit" ) }
end
