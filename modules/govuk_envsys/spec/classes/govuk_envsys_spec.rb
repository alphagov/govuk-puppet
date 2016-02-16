require_relative '../../../../spec_helper'

describe 'govuk_envsys', :type => :class do
  let(:file_path) { '/etc/environment' }
  context 'as a file not a template' do
    let(:facts) {{}}

    # with_content does not currently accept an argument.
    it { is_expected.to contain_file(file_path).with_source('puppet:///modules/govuk_envsys/etc/environment') }
  end
end
