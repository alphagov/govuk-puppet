# == Class: govuk_jenkins::job::govuk_cdn_nightly_2xx_status_collection
#
# Collect all GOV.UK URLs that returned a 2XX status for yesterday's site activity
#
#
# === Parameters:
#
# [*good_urls_file*]
#   The path to the file containing the know good URLs on GOV.UK
#
# [*log_dir*]
#   The path to the directory where the uncompressed daily log is stored
#
# [*processed_data_dir*]
#    The path to the directory where the processed data files are stored
#
class govuk_jenkins::job::govuk_cdn_nightly_2xx_status_collection (
  $good_urls_file = 'good_urls.csv',
  $log_dir = '/mnt/logs_cdn',
  $processed_data_dir = 'processed',
) {
  file { '/etc/jenkins_jobs/jobs/govuk_cdn_nightly_2xx_status_collection.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_cdn_nightly_2xx_status_collection.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
