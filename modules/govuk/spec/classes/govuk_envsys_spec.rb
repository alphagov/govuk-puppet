require_relative '../../../../spec_helper'

describe 'govuk::envsys', :type => :class do
  let(:file_path) { '/etc/environment' }
  context 'as a file not a template' do
    let(:facts) {{}}

    # with_content does not currently accept an argument.
    it { should contain_file(file_path).with_source('puppet:///modules/govuk/etc/environment') }
  end
end
