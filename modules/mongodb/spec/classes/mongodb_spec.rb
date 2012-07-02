require_relative '../../../../spec_helper'

describe 'mongodb', :type => :class do
  let(:facts) { { 'govuk_class' => 'preview', 'govuk_platform' => 'carlisAwesome' } }
  it { should contain_package('mongodb-10gen') }
  it { should contain_file('/etc/mongodb.conf') }
end
