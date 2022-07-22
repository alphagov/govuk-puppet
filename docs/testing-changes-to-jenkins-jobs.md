# Testing changes to Jenkins jobs

Our Jenkins jobs are configured in YAML ([example](https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_jenkins/templates/jobs/mirror_github_repositories.yaml.erb)).

If you ever need to test a change to the configuration of a Jenkins job, you could push your branch of govuk-puppet to GitHub, deploy it using the `Deploy_Puppet` Jenkins job, then wait half an hour for your changes to be applied. But this is an extremely slow feedback loop!

A much quicker way is to:

1. SSH onto the Jenkins machine (`gds govuk connect -e integration ssh jenkins`)
2. Disable Puppet on the machine (`govuk_puppet --disable "Testing changes to a Jenkins job"`)
3. Make your edits to the YAML on the machine, e.g. `sudo vi /etc/jenkins_jobs/jobs/mirror_github_repositories.yaml`
4. Recompile all the jobs: `/usr/local/bin/jenkins-jobs update --delete-old /etc/jenkins_jobs/jobs/`

Repeat steps 3 and 4 until you have the right configuration. Then re-enable Puppet (`govuk_puppet --enable`) and run `govuk_puppet --test` to reset back to the original configuration.
