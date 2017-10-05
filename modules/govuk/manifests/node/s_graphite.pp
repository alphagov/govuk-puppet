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
class govuk::node::s_graphite (
  $graphite_path = '/opt/graphite',
  $graphite_backup_hour = 23,
) inherits govuk::node::s_base {
  class { 'graphite':
    version                    => '0.9.13',
    port                       => '33333',
    carbon_aggregator          => true,
    aggregation_rules_source   => 'puppet:///modules/govuk/node/s_graphite/aggregation-rules.conf',
    storage_aggregation_source => 'puppet:///modules/govuk/node/s_graphite/storage-aggregation.conf',
    storage_schemas_source     => 'puppet:///modules/govuk/node/s_graphite/storage-schemas.conf',
    carbon_source              => 'puppet:///modules/govuk/node/s_graphite/carbon.conf',
    require                    => Govuk_mount[$graphite_path],
  }

  # FIXME: Remove this patch when Graphite is upgraded past 0.9.13
  # This patch is https://github.com/graphite-project/carbon/pull/351 - the bug
  # that this fixes was released as part of 0.9.13 which breaks all of our
  # carbon-aggregator metrics.
  $service_py = "${graphite_path}/lib/carbon/service.py"
  $service_patch = "${graphite_path}/graphite_carbon_service.patch"
  $service_patched_md5 = '0559bf74463b14f4070e3cf8a2584fff'
  file { $service_patch:
    ensure => file,
    source => 'puppet:///modules/govuk/node/s_graphite/graphite_carbon_service.patch',
  }
  exec { 'patch graphite 0.9.13 carbon':
    command => "/usr/bin/patch -b ${service_py} ${service_patch}",
    unless  => "/usr/bin/md5sum ${service_py} | /bin/grep -qsw ${service_patched_md5}",
    notify  => Class['graphite::service'],
    require => [
      Class['graphite::install'],
      File[$service_patch],
    ],
  }

  limits::limits { 'www-data_nofile':
    ensure     => present,
    user       => 'www-data',
    limit_type => 'nofile',
    both       => 16384,
    notify     => Class['graphite::service'],
  }

  @@icinga::check { "check_carbon_cache_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-cache.py',
    service_description => 'carbon-cache running',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_carbon_aggregator_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-aggregat',
    service_description => 'carbon-aggregator running',
    host_name           => $::fqdn,
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

  nginx::config::vhost::proxy { 'graphite':
    to           => ['localhost:33333'],
    root         => "${graphite_path}/webapp",
    aliases      => ['graphite.*'],
    protected    => false,
    extra_config => $cors_headers,
  }

  ## Make compressed archives of Whisper data to backup off-box rather than
  ## backing up the raw files
  file { '/usr/local/bin/govuk_backup_graphite_whisper_files':
    ensure => present,
    source => 'puppet:///modules/govuk/usr/local/bin/govuk_backup_graphite_whisper_files',
    mode   => '0755',
  }

  file { '/usr/local/bin/govuk_delete_ephemeral_interface_data':
    ensure => present,
    source => 'puppet:///modules/govuk/usr/local/bin/govuk_delete_ephemeral_interface_data',
    mode   => '0755',
  }

  package { 'pigz':
    ensure => installed,
  }

  file { '/opt/graphite/storage/backups':
    ensure => 'directory',
    owner  => 'govuk-backup',
    group  => 'govuk-backup',
    mode   => '0770',
  }

  cron::crondotdee { 'create_compressed_archive_of_whisper_data':
    command => '/usr/local/bin/govuk_backup_graphite_whisper_files',
    hour    => $graphite_backup_hour,
    minute  => 45,
  }

  cron::crondotdee { 'delete_ephemeral_interface_data_from_ci_agents':
    command => '/usr/local/bin/govuk_delete_ephemeral_interface_data',
    hour    => $graphite_backup_hour,
    minute  => 30,
  }

  if ! $::aws_migration {
    include collectd::server
  }

  include grafana
  include govuk_containers::grafana
}
