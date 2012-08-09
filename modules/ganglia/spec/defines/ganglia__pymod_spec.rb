require_relative '../../../../spec_helper'

describe 'ganglia::pymod', :type => :define do
  let(:title) { 'elephant' }
  let(:params) { {:content => 'elephant content'} }

  it do
    should contain_file('/usr/lib/ganglia/python_modules/elephant.py').with_content('elephant content').with_mode('0755')
  end
end
