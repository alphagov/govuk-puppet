require_relative '../../../../spec_helper'

describe 'backup::offsite', :type => :class do
  context 'hostname => ice.cream, hostkey => pickle' do
    let(:params) {{
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    }}

    it {
      # Leaky abstraction? We need to know that govuk::user creates the
      # parent directory for our file.
      should contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
    }

    it {
      should contain_sshkey('ice.cream').with_key('pickle')
    }

    it {
      should contain_file('/usr/local/bin/offsite-backup').with_content(/^scp \$SSH_OPTS \$TEMP_FILE \${DEST}:\${FILENAME}$/)
    }

    it {
      should contain_file('/usr/local/bin/offsite-backup').with_content(/^DEST="ice.cream"$/)
    }

    it {
      should_not contain_file('/usr/local/bin/offsite-backup').with_content(/^exit 0$/)
    }
  end
  context 'hostname => ice.cream, hostkey => pickle' do
    let(:params) {{
      :dest_folder   => 'cheesecake/',
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    }}

    it {
      should contain_file('/usr/local/bin/offsite-backup').with_content(/^scp \$SSH_OPTS \$TEMP_FILE \${DEST}:cheesecake\/\${FILENAME}$/)
    }
  end
  context 'enable => false' do
    let(:params) {{
      :dest_folder   => 'lemon/tart',
      :dest_host     => 'apple.turnover',
      :dest_host_key => 'cinnamonbun',
      :enable        => false,
    }}

    it {
      should contain_file('/usr/local/bin/offsite-backup').with_content(/^exit 0$/)
    }
  end
end
