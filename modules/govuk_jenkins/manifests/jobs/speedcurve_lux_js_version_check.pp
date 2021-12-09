# == Class: govuk_jenkins::jobs::speedcurve_lux_js_version_check
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::speedcurve_lux_js_version_check {
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/speedcurve-lux-js-version-check/"
  $service_description = 'SpeedCurve LUX JavaScript version check'

  file {
    '/etc/jenkins_jobs/jobs/speedcurve_lux_js_version_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/speedcurve_lux_js_version_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check { "speedcurve_lux_js_version_check_${::hostname}":
    service_description     => $service_description,
    host_name               => $::fqdn,
    freshness_threshold     => 86400, # 24 hours
    freshness_alert_level   => 'warning',
    freshness_alert_message => 'SpeedCurve LUX JavaScript version check has stopped running or is unstable',
    action_url              => $job_url,
    notes_url               => monitoring_docs_url(speedcurve-lux-js-version-check),
  }
}
