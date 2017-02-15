require_relative '../../../../spec_helper'

describe 'govuk_tune_ext', :type => :define do
  let(:title) { 'tune_me' }

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

end
