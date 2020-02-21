# == Define: govuk_jenkins::jobs::athena_fastly_logs_check::icinga_database_check
#
# Definition used to iterate through an array of database names and set-up
# Icinga passive checks for each one of these.
#
# This should only have to exist as a seperate defined resource until the
# eventual day that we upgrade Puppet to allow the future syntax where we
# can iterate through the array.
#
# === Parameters
#
# [*jenkins_url*]
#
# A URL to the Jenkins job which is linked to by this alert. This URL will
# be given a query string to filter the jobs listed to only those for this
# particular database.
#
# [*service_description*]
#
# The description that is shown in Icinga for this check. It is expected to
# have a variable interpolated of $DATABASE, this is replaced for the database
# name that is under check.
define govuk_jenkins::jobs::athena_fastly_logs_check::icinga_database_check (
  $jenkins_url = undef,
  $service_description = undef,
) {
  @@icinga::passive_check {
    "athena_fastly_logs_check_${name}_${::hostname}":
      service_description     => regsubst($service_description, '\$\{DATABASE\}', $name),
      host_name               => $::fqdn,
      freshness_threshold     => 86400, # 24 hours
      freshness_alert_level   => 'warning',
      freshness_alert_message => 'Jenkins job has stopped running or is unstable',
      action_url              => "${jenkins_url}?search=${name}",
      notes_url               => monitoring_docs_url(athena-fastly-logs-check),
  }
}
