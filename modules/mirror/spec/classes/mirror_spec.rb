require_relative '../../../../spec_helper'

describe 'mirror', :type => :class do
  before :each do
    update_extdata({'govuk_gemfury_source_url' => 'https://some_token@gem.fury.io/govuk/',})
  end

  it do
    should contain_file('/usr/local/bin/govuk_update_mirror')
    should_not raise_error(Puppet::ParseError)
  end

  it {
    # Leaky abstraction? We need to know that govuk::user creates the
    # parent directory for our file.
    should contain_file('/home/govuk-netstorage/.ssh').with_ensure('directory')
  }
  it {
    should contain_file('/home/govuk-netstorage/.ssh/id_rsa').with_ensure('file')
  }
end
