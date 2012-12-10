require_relative '../../../../spec_helper'

describe 'datainsight::config::google_oauth', :type => :class do
  it do
    should contain_file('/etc/gds/google_credentials.yml')
          .with_content(/example client id/)
          .with_content(/example client secret/)

    should contain_file('/var/lib/gds/google-analytics-token.yml')
          .with_content(/example refresh token/)

    should contain_file('/var/lib/gds/google-drive-token.yml')
          .with_content(/example refresh token/)
  end
end
