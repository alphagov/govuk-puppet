# == Class: govuk_jenkins::job::backdrop_transactions_explorer_collector
#
# Backdrop collector for the Transactions Explorer Google Spreadsheet
#
class govuk_jenkins::job::backdrop_transactions_explorer_collector (
  $google_credentials = undef,
  $google_spreadsheet_key = undef,
  $google_spreadsheet_worksheet = undef,
  $backdrop_token = undef,
) {

  file { '/etc/jenkins_jobs/jobs/backdrop_transactions_explorer_collector.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/backdrop_transactions_explorer_collector.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
