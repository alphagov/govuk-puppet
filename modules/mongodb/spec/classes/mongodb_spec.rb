require_relative '../../../../spec_helper'

describe 'mongodb::server', :type => :class do
  let(:facts) { { 'govuk_class' => 'preview', 'govuk_platform' => 'carlisAwesome' } }
  it do
    should contain_package('mongodb-10gen')
    should contain_file('/etc/mongodb.conf')
  end
end
