require_relative '../../../../spec_helper'

describe 'jenkins::slave', :type => :class do
  let(:ssh_dir) { '/home/jenkins/.ssh' }
  let(:ssh_file) { '/home/jenkins/.ssh/authorized_keys' }

  it { should include_class('jenkins') }
  it { should include_class('jenkins::ssh_key') }
  it { should contain_file(ssh_dir).with_ensure('directory') }

  it {
    should contain_file(ssh_file).with(
      :ensure  => 'present',
      :content => /^ssh/,
    )
  }
end
