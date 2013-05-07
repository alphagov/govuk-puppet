require_relative '../../../../spec_helper'

describe 'jenkins', :type => :class do
  let(:ssh_dir) { '/home/jenkins/.ssh' }
  let(:ssh_file) { '/home/jenkins/.ssh/authorized_keys' }

  it { should include_class('jenkins::ssh_key') }
  it { should contain_file(ssh_dir).with_ensure('directory') }

  it { should contain_user('jenkins').with_ensure('present') }
  it { should contain_file(ssh_file).with_ensure('absent') }
end
