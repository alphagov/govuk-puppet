require_relative '../../../../spec_helper'

describe 'govuk_rbenv', :type => :class do

  it { is_expected.to compile }

  it { is_expected.to contain_rbenv__version('1.9.3-p550') }

  context 'all rubies' do
    let (:params) {{ :rubies => 'all' }}

    it { is_expected.to contain_rbenv__version('2.2.2') }
  end

end
