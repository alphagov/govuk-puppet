task :check_jenkins_jobs do
  require 'set'
  require 'yaml'

  defined_jobs = Dir.glob("modules/govuk_jenkins/manifests/jobs/*").map { |e| e.split("/").last.gsub(".pp", "") }

  jobs = Set.new

  %w[
    hieradata_aws/class/integration/jenkins.yaml
    hieradata_aws/class/production/jenkins.yaml
    hieradata_aws/class/staging/jenkins.yaml
    hieradata_aws/class/training/jenkins.yaml
    hieradata/class/integration/jenkins.yaml
    hieradata/class/production/jenkins.yaml
    hieradata/class/staging/jenkins.yaml
    hieradata/class/training/jenkins.yaml
  ].each do |filename|
    jobs.merge YAML.load_file(filename)["govuk_jenkins::job_builder::jobs"]
  end

  loaded_jobs = jobs.map { |job| job.gsub("govuk_jenkins::jobs::", "") }

  unused_jobs = defined_jobs - loaded_jobs

  if unused_jobs.any?
    raise "The following Jenkins jobs are defined but aren't included in any Jenkins instance: #{unused_jobs}"
  end
end
