require_relative '../../../../spec_helper'

describe 'govuk_envvar', :type => :define do
  context 'with a value' do
    let(:title) { 'GOVUK_POET_FULL_NAME' }
    let(:params) { { :value => 'Robert Burns' } }

    it 'writes the value to disk' do
      is_expected.to contain_file('/etc/govuk/env.d/GOVUK_POET_FULL_NAME')
                 .with_content('Robert Burns')
    end
  end

  context 'without a value' do
    let(:title) { 'GOVUK_POET_FULL_NAME' }

    it 'writes an empty value to disk' do
      is_expected.to contain_file('/etc/govuk/env.d/GOVUK_POET_FULL_NAME')
                 .with_content('')
    end
  end
end
