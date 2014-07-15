require_relative '../../../../spec_helper'

describe 'govuk::user', :type => :define do
  let(:title) { 'hungrycaterpillar' }
  let(:ssh_dir) { '/home/hungrycaterpillar/.ssh' }
  let(:ssh_file) { '/home/hungrycaterpillar/.ssh/authorized_keys' }

  context 'default params' do
    let(:params) {{
      :fullname => 'Hungry Caterpillar',
      :email    => 'hungry.caterpillar@example.com',
    }}

    it { should contain_user('hungrycaterpillar').with_ensure('present') }
    it { should contain_file(ssh_dir).with_ensure('directory') }
    it {
      should contain_file(ssh_file).with(
        :ensure  => 'absent',
        :content => nil,
      )
    }
  end

  context 'ensure absent' do
    let(:params) {{
      :ensure   => 'absent',
      :fullname => 'Hungry Caterpillar',
      :email    => 'hungry.caterpillar@example.com',
      :ssh_key  => 'should be ignored',
    }}

    it { should contain_user('hungrycaterpillar').with_ensure('absent') }
    it { should contain_file(ssh_dir).with_ensure(nil) }
    it {
      should contain_file(ssh_file).with(
        :ensure  => 'absent',
        :content => nil,
      )
    }
  end

  context 'ssh_key as string' do
    let(:params) {{
      :ssh_key  => 'ssh-rsa cupcake',
      :fullname => 'Hungry Caterpillar',
      :email    => 'hungry.caterpillar@example.com',
    }}

    it {
      should contain_file(ssh_file).with(
        :ensure => 'present',
        :content => "ssh-rsa cupcake\n",
      )
    }
  end

  context 'ssh_key as array in non-alphabetical order' do
    let(:params) {{
      :ssh_key  => ['ssh-rsa watermelon', 'ssh-dss pickle', 'ssh-rsa lollipop'],
      :fullname => 'Hungry Caterpillar',
      :email    => 'hungry.caterpillar@example.com',
    }}

    it {
      should contain_file(ssh_file).with(
        :ensure => 'present',
        :content => <<EOS
ssh-dss pickle
ssh-rsa lollipop
ssh-rsa watermelon
EOS
      )
    }
  end
end
