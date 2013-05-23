require_relative '../../../../spec_helper'

describe 'govuk::deploy::setup', :type => :class do
  let(:file_path) { '/home/deploy/.ssh/authorized_keys' }

  context 'with all keys present in extdata' do
    before {
      update_extdata({
        'jenkins_key'                     => 'oneapple',
        'jenkins_skyscape_key'            => 'twopears',
        'jenkins_skyscape_production_key' => 'threeplums',
        'deploy_user_data_sync_key'       => 'fourstrawberries',
      })
    }
    # FIXME: Hack to refresh extdata.
    let(:facts) {{ :cache_bust => Time.now }}

    it 'authorized_keys should have all keys active and sorted by comment' do
      should contain_file(file_path).with_content(<<EOS
ssh-rsa fourstrawberries deploy_user_data_sync_key
ssh-rsa oneapple jenkins_key
ssh-rsa twopears jenkins_skyscape_key
ssh-rsa threeplums jenkins_skyscape_production_key
EOS
      )
    end
  end

  context 'with no keys present in extdata' do
    # FIXME: Hack to refresh extdata.
    let(:facts) {{ :cache_bust => Time.now }}

    it 'authorized_keys should only contain commented keys' do
      should contain_file(file_path).with_content(/ NONE_IN_EXTDATA /)
      should_not contain_file(file_path).with_content(/^[^#]/)
    end
  end
end
