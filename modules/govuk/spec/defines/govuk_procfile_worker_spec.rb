require_relative '../../../../spec_helper'

describe 'govuk::procfile::worker', :type => :define do
  let(:title) { 'giraffe' }

  context "in non-development environments" do

    it do
      should contain_file("/etc/init/giraffe-procfile-worker.conf").with(
        :content => /start on runlevel/
      )
    end

    it { should contain_service("giraffe-procfile-worker").with(:ensure => true) }
  end

  context "in development environments" do
    let(:facts) { {:govuk_platform => "development"} }

    it do
      should contain_file("/etc/init/giraffe-procfile-worker.conf")
      should_not contain_file("/etc/init/giraffe-procfile-worker.conf").with(
        :content => /start on runlevel/
      )
    end

    it { should contain_service("giraffe-procfile-worker").with(:ensure => false) }
  end
end
