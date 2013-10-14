require_relative '../../../../spec_helper'

describe 'postgres::postgis', :type => :class do
  let(:facts) {{
    :lsbdistcodename => 'Precise',
  }}

  it { should contain_package("postgis") }
end
