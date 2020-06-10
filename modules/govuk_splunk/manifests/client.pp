# == Class: backup::client
#
# Configures a machine to use a user for splunk.
#

govuk_user { 'splunk':
  fullname    => 'Slunk User',
  email       => 'cyber.security@digital.cabinet-office.gov.uk',
  groups      => ['splunk'],
  purgegroups => true,
}
group { 'splunk':
  ensure => $ensure,
}
