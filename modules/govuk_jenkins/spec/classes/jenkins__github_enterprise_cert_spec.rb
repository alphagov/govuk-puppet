require_relative '../../../../spec_helper'

describe 'govuk_jenkins::github_enterprise_cert', :type => :class do

  let(:params) {{
    :certificate => 'certcertcert',
    :certificate_path => 'wobble',
    :github_enterprise_hostname => 'dibble',
  }}

  it { is_expected.to contain_file('wobble').with_content(/certcertcert/) }

end
