require_relative '../../../../spec_helper'

describe 'backup::server', :type => :class do
  it { should_not raise_error(Puppet::ParseError) }

  it {
    # Leaky abstraction? We need to know that govuk::user creates the
    # parent directory for our file.
    should contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
  }
  it {
    should contain_file('/home/govuk-backup/.ssh/id_rsa').with_ensure('file')
  }
end
