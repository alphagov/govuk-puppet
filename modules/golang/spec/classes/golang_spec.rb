require_relative '../../../../spec_helper'

describe 'golang', :type => :class do
  let(:file_path) { '/etc/profile.d/gopath.sh' }
  let(:go_path){ 'export GOPATH=/var/govuk/gopath' }

  context 'in development' do
    let(:facts) {{domain: 'development'}}
    it {
      is_expected.to contain_file(file_path).
        with_source('puppet:///modules/golang/etc/profile.d/gopath.sh')
    }
  end

  context 'not in development' do
    let(:facts) {{domain: 'somethingelse'}}
    it { is_expected.not_to contain_file(file_path) }
  end
end
