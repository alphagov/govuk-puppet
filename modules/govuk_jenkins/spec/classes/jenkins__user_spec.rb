require_relative '../../../../spec_helper'

describe 'govuk_jenkins::user', :type => :class do

  let(:params) {{
    :home_directory => '/var/lib/jenkins',
    :username => 'jenkins',
  }}

  it { is_expected.to contain_user('jenkins') }
end
