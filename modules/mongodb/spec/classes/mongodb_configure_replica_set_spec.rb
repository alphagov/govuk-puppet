require_relative '../../../../spec_helper'

describe 'mongodb::configure_replica_set', :type => :class do
  let(:params) { { 'members' => ['123.456.789.123', '987.654.321.012', '432.434.454.454:457'] } }
  let(:facts) { { 'govuk_class' => 'preview', 'govuk_platform' => 'carlisAwesome' } }
  it { should contain_file('/etc/mongodb/configure-replica-set.js') }
end
