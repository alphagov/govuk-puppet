require_relative '../../../../spec_helper'

describe 'backup::server', :type => :class do
  it {
    # Leaky abstraction? We need to know that govuk_user creates the
    # parent directory for our file.
    is_expected.to contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
  }
  it {
    is_expected.to contain_file('/home/govuk-backup/.ssh/id_rsa').with_ensure('file')
  }
end
