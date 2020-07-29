require_relative '../../../../spec_helper'

describe 'govuk::deploy::setup', :type => :class do
  let(:authorized_keys_path) { '/home/deploy/.ssh/authorized_keys' }

  context 'keys provided' do
    let(:params) {{
      'actionmailer_enable_delivery' => true,
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
      is_expected.to contain_file(authorized_keys_path).with_content(<<eos
ssh-rsa twopears bar
ssh-rsa threeplums baz
ssh-rsa oneapple foo
eos
      )
    end
  end

  context 'keys not provided' do
    let(:params) {{
      'actionmailer_enable_delivery' => false,
      'aws_ses_smtp_host'     => 'UNSET',
      'aws_ses_smtp_username' => 'UNSET',
      'aws_ses_smtp_password' => 'UNSET',
    }}

    it 'authorized_keys should only contain commented keys' do
      is_expected.to contain_file(authorized_keys_path).with_content(/ NONE_IN_HIERA /)
      is_expected.to contain_file(authorized_keys_path).without_content(/^[^#]/)
    end
  end
end
