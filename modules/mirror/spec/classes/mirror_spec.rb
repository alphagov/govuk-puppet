require_relative '../../../../spec_helper'

describe 'mirror', :type => :class do
  before :each do
    update_extdata({'govuk_gemfury_source_url' => 'https://some_token@gem.fury.io/govuk/'})
  end

  it { should contain_file('/usr/local/bin/govuk_update_mirror') }

  it {
    # Leaky abstraction? We need to know that govuk::user creates the
    # parent directory for our file.
    should contain_file('/home/govuk-netstorage/.ssh').with_ensure('directory')
  }
  it {
    should contain_file('/home/govuk-netstorage/.ssh/id_rsa').with_ensure('file')
  }

  describe "#enable" do
    context "false (default)" do
      let(:params) {{ }}

      it { should contain_cron('update-latest-to-mirror').with_ensure('absent') }
    end

    context "true" do
      let(:params) {{
        :enable => true,
      }}

      it { should contain_cron('update-latest-to-mirror').with_ensure('present') }
    end
  end

  describe "#targets" do
    context "[] (default)" do
      let(:params) {{ }}

      it { should contain_file('/usr/local/bin/govuk_upload_mirror').with_content(/^TARGETS=""$/) }
    end

     context "string" do
       let(:params) {{
         :targets => 'user102@mirror102',
       }}

       it { expect { should }.to raise_error(Puppet::Error, /is not an Array/) }
    end

     context "array of items" do
       let(:params) {{
         :targets => ['user101@mirror101', 'user102@mirror102'],
       }}

       it { should contain_file('/usr/local/bin/govuk_upload_mirror').with_content(/^TARGETS="user101@mirror101 user102@mirror102"$/) }
     end
  end

end
