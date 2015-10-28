require_relative '../../../../spec_helper'

describe 'govuk::delayed_job::worker', :type => :define do
  let(:title) { 'giraffe' }

  context "in non-development environments" do

    it do
      is_expected.to contain_file("/etc/init/giraffe-delayed-job-worker.conf").
        without_content(/manual/)
    end

    it { is_expected.to contain_service("giraffe-delayed-job-worker").with(:ensure => true) }
  end

  context "in development environments" do
    let(:params) { {:enable_service => false} }

    it do
      is_expected.to contain_file("/etc/init/giraffe-delayed-job-worker.conf").
        with_content(/^manual$/)
    end

    it { is_expected.to contain_service("giraffe-delayed-job-worker").with(:ensure => false) }
  end
end
