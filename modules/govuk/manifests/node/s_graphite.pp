# == Class: govuk::node::s_graphite
#
# Class to specify a machine for gathering and storing metrics.
#
# === Parameters:
#
# [*graphite_path*]
#   Path to the installation of Graphite.
#
# [*graphite_backup_hour*]
#   Hour of the day to run the backup crons.
#
#  [*apt_mirror_hostname*]
#    The hostname of the local aptly mirror.
#
#  [*apt_mirror_gpg_key_fingerprint*]
#    The fingerprint of the local aptly mirror.
#

class govuk::node::s_graphite (
  $graphite_path = '/opt/graphite',
  $graphite_backup_hour = 23,
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) inherits govuk::node::s_base {
  class { 'graphite':
    version                    => '1.0.0',
    port                       => '33333',
    worker_processes           => 4,
    carbon_aggregator          => true,
    aggregation_rules_source   => 'puppet:///modules/govuk/node/s_graphite/aggregation-rules.conf',
    storage_aggregation_source => 'puppet:///modules/govuk/node/s_graphite/storage-aggregation.conf',
    storage_schemas_source     => 'puppet:///modules/govuk/node/s_graphite/storage-schemas.conf',
    carbon_source              => 'puppet:///modules/govuk/node/s_graphite/carbon.conf',
    require                    => Govuk_mount[$graphite_path],
  }

  exec { 'migrate graphite database':
    command => "env PYTHONPATH=${graphite_path}/webapp ${graphite_path}/bin/django-admin.py migrate --noinput --settings=graphite.settings --run-syncdb",
    notify  => Class['graphite::service'],
    require => Class['graphite::install'],
  }

  @@icinga::check { "check_carbon_cache_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-cache.py',
    service_description => 'carbon-cache not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

  @@icinga::check { "check_carbon_aggregator_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-aggregat',
    service_description => 'carbon-aggregator not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

  @ufw::allow {
    'allow-graphite-2003-from-all':
      port => 2003;
    'allow-graphite-2004-from-all':
      port => 2004;
    'allow-graphite-7002-from-all':
      port => 7002;
  }

  include ::nginx

  $cors_headers = '
  add_header "Access-Control-Allow-Origin" "*";
  add_header "Access-Control-Allow-Methods" "GET, OPTIONS";
  add_header "Access-Control-Allow-Headers" "origin, authorization, accept";
'

  nginx::config::vhost::default { 'default': }
  $graphite_aliases = undef

  nginx::config::vhost::proxy { 'graphite':
    to           => ['localhost:33333'],
    root         => "${graphite_path}/webapp",
    aliases      => $graphite_aliases,
    protected    => false,
    read_timeout => 30,
    extra_config => $cors_headers,
  }

  $remove_old_whisper_data_bin = '/usr/local/bin/remove-old-whisper-data'

  file { $remove_old_whisper_data_bin:
    ensure  => present,
    content => template('govuk/node/s_graphite/remove_old_whisper_data.erb'),
    mode    => '0755',
  }

  cron::crondotdee { 'remove-old-whisper-data':
    command => $remove_old_whisper_data_bin,
    hour    => 2,
    minute  => 0,
    require => File[$remove_old_whisper_data_bin],
  }

  ## Backing up whisper database directly to S3 using the whisper-backup script
  apt::source { 'whisper-backup':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/whisper-backup",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'whisper-backup':
    ensure  => installed,
    require => Apt::Source['whisper-backup'],
  }

  package { 'python-snappy':
    ensure => installed,
  }

  $s3_database_backups_bucket = "govuk-${::aws_environment}-database-backups"
  $source_path = "${graphite_path}/storage/whisper/"
  $destination_path = '/whisper/'
  $s3_backup_cmd = "whisper-backup -a sz -b ${s3_database_backups_bucket} -p ${source_path} --storage-path=${destination_path} backup s3 eu-west-1"

  cron::crondotdee { 'backup_whisper_database_to_s3':
    command => $s3_backup_cmd,
    hour    => $graphite_backup_hour,
    minute  => 5,
  }

  include grafana
}
