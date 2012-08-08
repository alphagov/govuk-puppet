require_relative '../../../../spec_helper'

describe 'ganglia::pyconf', :type => :define do
  let(:title) { 'monkey' }
  let(:params) { {:content => 'monkey content'} }

  it do
    should contain_file('/etc/ganglia/conf.d/monkey.pyconf').with_content('monkey content')
  end
end
