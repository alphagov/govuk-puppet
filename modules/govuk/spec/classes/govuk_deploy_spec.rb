require_relative '../../../../spec_helper'

describe 'govuk::deploy::setup', :type => :class do
  let(:file_path) { '/home/deploy/.ssh/authorized_keys' }

  context 'keys provided' do
    let(:params) {{
      'setup_actionmailer_ses_config' => true,
      'aws_ses_smtp_host'     => 'email-smtp.aws.example.com',
      'aws_ses_smtp_username' => 'a_username',
      'aws_ses_smtp_password' => 'a_password',
      'ssh_keys'              => {
        'foo' => 'oneapple',
        'bar' => 'twopears',
        'baz' => 'threeplums',
      }
    }}

    it 'authorized_keys should have all keys active and sorted by comment' do
      should contain_file(file_path).with_content(<<EOS
ssh-rsa twopears bar
ssh-rsa threeplums baz
ssh-rsa oneapple foo
EOS
      )
    end
  end

  context 'keys not provided' do
    let(:params) {{
      'setup_actionmailer_ses_config' => false,
      'aws_ses_smtp_host'     => 'UNSET',
      'aws_ses_smtp_username' => 'UNSET',
      'aws_ses_smtp_password' => 'UNSET',
    }}

    it 'authorized_keys should only contain commented keys' do
      should contain_file(file_path).with_content(/ NONE_IN_HIERA /)
      should contain_file(file_path).without_content(/^[^#]/)
    end
  end
end
