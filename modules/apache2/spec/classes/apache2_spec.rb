require_relative '../../../../spec_helper'

describe 'apache2', :type => :class do
  let(:facts) { { :apache_port => '8080' } }
  it { should create_package("apache2") }
end
