require_relative '../../../../spec_helper'

describe 'mongodb::server', :type => :class do
  let(:facts) {{
    :govuk_platform => 'test',
  }}

  describe "with the default package name" do
    let(:params) { { 'version' => '2.4.6' } }
    it do
      should contain_package('mongodb-10gen').with_ensure('2.4.6')
      should contain_file('/etc/mongodb.conf')
    end
  end

  describe "overriding the package name" do
    let(:params) { {
      'version' => '2.0.7',
      'package_name' => 'mongodb20-10gen',
    } }

    it do
      should contain_package('mongodb20-10gen').with_ensure('2.0.7')
      should contain_file('/etc/mongodb.conf')
    end
  end
end
