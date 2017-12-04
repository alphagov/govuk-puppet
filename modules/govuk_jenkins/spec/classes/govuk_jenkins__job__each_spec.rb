require_relative '../../../../spec_helper'

job_directory = File.join(File.dirname(__FILE__), '../../manifests/job')
FILES = Dir.entries(job_directory).reject{ |f| f == "." || f == ".." }

# TODO: make the specs work for these
BROKEN_SPECS = %w[
  copy_data_from_integration_to_aws.pp
  copy_data_to_integration.pp
  copy_data_to_staging.pp
  deploy_cdn.pp
  deploy_puppet.pp
  email_alert_rake_tasks.pp
  smokey.pp
  update_cdn_dictionaries.pp
  whitehall_update_integration_data.pp
]

# test everything apart from known broken exceptions
FILES = FILES - BROKEN_SPECS

FILES.each do |filename|
  classname = filename.split(".")[0]

  describe "govuk_jenkins::jobs::#{classname}", :type => :class do

    let(:pre_condition) { 'include govuk_jenkins::job_builder_update' }

    it { is_expected.to compile }

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class("govuk_jenkins::jobs::#{classname}") }
  end
end
