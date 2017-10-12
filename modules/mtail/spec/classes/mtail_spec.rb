require_relative '../../../../spec_helper'

describe 'mtail', :type => :class do

  context "logs => /var/log/nginx/access.log" do
    let(:params) {{
      :logs => '/var/log/nginx/access.log',
    }}

    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_package('mtail') }
    it { is_expected.to contain_service('mtail') }

    it { is_expected.to contain_file('/etc/default/mtail').with_content(/LOGS="\/var\/log\/nginx\/access\.log"$/) }
  end
end
