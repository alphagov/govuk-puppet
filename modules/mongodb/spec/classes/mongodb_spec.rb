require_relative '../../../../spec_helper'

describe 'mongodb::server', :type => :class do
  let(:facts) { { 'govuk_class' => 'test', 'govuk_platform' => 'test' } }
  it do
    should contain_package('mongodb20-10gen')
    should contain_file('/etc/mongodb.conf')
  end
end
