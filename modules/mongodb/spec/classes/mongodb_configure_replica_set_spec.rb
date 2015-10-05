require_relative '../../../../spec_helper'

describe 'mongodb::configure_replica_set', :type => :class do
  describe 'configure-replica-set' do
    describe 'sets replica set name' do
      let(:params) {{
        'members'         => {
          '123.456.789.123' => {},
          '987.654.321.012' => {},
          '432.434.454.454:457' => {},
        },
        'replicaset_name' => 'production',
      }}

      it {
        is_expected.to contain_file('/etc/mongodb/configure-replica-set.js').with_content(
          /_id: "production"/)
      }
    end
  end
end
