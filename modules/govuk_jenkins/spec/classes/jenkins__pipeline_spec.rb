require_relative '../../../../spec_helper'

describe 'govuk_jenkins::pipeline', :type => :class do
  describe 'manage config' do
    it { is_expected.to contain_file('/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml').with_content(/<name>govuk<\/name/) }
    it { is_expected.to contain_file('/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml').with_content(/<repoOwner>alphagov<\/repoOwner>/) }
    it { is_expected.to contain_file('/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml').with_content(/<repository>govuk-jenkinslib<\/repository>/) }
    it { is_expected.to contain_file('/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml').with_content(/<defaultVersion>master<\/defaultVersion>/) }
    it { is_expected.to contain_file('/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml').with_content(/<implicit>false<\/implicit>/) }
  end
end
