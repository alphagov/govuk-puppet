require_relative '../../../../spec_helper'

describe "govuk_rbenv::install_ruby_version", :type => :define do
  let(:title) { '2.5.1' }

  it { is_expected.to contain_rbenv__version(title) }

  context "when with_foreman is true" do
    let(:params) { { :with_foreman => true } }

    it do
      is_expected.to contain_exec('install foreman for ruby 2.5.1')
        .with_command(%r{gem install foreman})
    end
  end

  context "when with_foreman is false" do
    let(:params) { { :with_foreman => false } }

    it { is_expected.not_to contain_exec('install foreman for ruby 2.5.1') }
  end
end
