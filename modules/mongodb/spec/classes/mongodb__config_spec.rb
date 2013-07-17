require_relative '../../../../spec_helper'

describe 'mongodb::config', :type => :class do
  let(:params) {{
    :replicaset => 'bar',
    :logpath    => '/this/is/a/path',
  }}

  it {
    should contain_file('/etc/init/mongodb.conf').with_content(
/^\s*exec start-stop-daemon --start --quiet --chuid mongodb \
-p \/var\/lib\/mongodb\/mongod.lock --startas \/usr\/bin\/mongod -- \
--logpath "\/this\/is\/a\/path" --logappend --config "\/etc\/mongodb.conf"$/
    )
  }
end

