require_relative '../../../../spec_helper'

job_directory = File.join(File.dirname(__FILE__), '../../manifests/job')
FILES = Dir.entries(job_directory).reject{ |f| f == "." || f == ".." }

FILES.each do |filename|
  classname = filename.split(".")[0]

  describe "govuk_jenkins::job::#{classname}", :type => :class do

    let(:pre_condition) { 'include govuk_jenkins::job_builder_update' }

    it { is_expected.to compile }

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class("govuk_jenkins::job::#{classname}") }
  end
end
