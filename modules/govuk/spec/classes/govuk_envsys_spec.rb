require_relative '../../../../spec_helper'

describe 'govuk::envsys', :type => :class do
  let(:file_path) { '/etc/environment' }
  context 'with no govuk vars' do
    let(:facts) {{}}

    # with_content does not currently accept an argument.
    it { should contain_file(file_path).with_content(/^(PATH|LC_ALL)/) }
    it { should_not contain_file(file_path).with_content(/FACTER_govuk/) }
  end

  context 'with govuk vars' do
    let(:facts) {{
      :govuk_platform => 'foo',
    }}

    it { should contain_file(file_path).with_content(/^FACTER_govuk_platform=foo$/) }
  end
end
