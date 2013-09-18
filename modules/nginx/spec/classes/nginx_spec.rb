require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  let(:facts) {{
    :lsbdistcodename => 'Precise',
  }}

  it do
    should contain_package('nginx')
  end
end
