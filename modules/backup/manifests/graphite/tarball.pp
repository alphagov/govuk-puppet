# Create a nightly backup of graphite metrics as a local tarball
#
# [*enabled*]
#   Whether to create nightly backups of Graphite
#   Default: True
#
# [*backup_directory*]
#   Directory to place the backups in
#   Default: '/opt/graphite/backup'
#
# [*whisper_directory*]
#   Directory containing the graphite whisper files
#   Default: '/opt/graphite/storage/whisper'
#
# [*icinga_check*]
#   Whether to submit results as a passive check to Nagios/Icinga
#   Default: True
#
class backup::graphite::tarball (
    $enabled           = true,
    $backup_directory  = '/opt/graphite/backup',
    $whisper_directory = '/opt/graphite/storage/whisper',
    $icinga_check      = true,
) {

  validate_bool($enabled)
  validate_bool($icinga_check)

  if ($enabled) {
    $graphite_backup     = 'present'
    $graphite_backup_dir = 'directory'
  } else {
    $graphite_backup     = 'absent'
    $graphite_backup_dir = 'absent'
  }

  file { $backup_directory:
    ensure  => $graphite_backup_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    require => Class['graphite'],
  }

  $service_desc = 'Graphite nightly tarball backup creation'
  file { '/usr/local/bin/graphite_tarball':
    ensure  => $graphite_backup,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('backup/usr/local/bin/graphite_tarball.erb'),
    require => File[$backup_directory]
  }

  if ($icinga_check) {
    # Freshness threshold should be 28 hours
    $threshold_secs = 28 * (60 * 60)
    @@icinga::passive_check { "graphite-nightly-tarball-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }

  cron { 'graphite-nightly-tarball':
    ensure  => $graphite_backup,
    command => '/usr/local/bin/graphite_tarball',
    user    => 'root',
    hour    => 3,
    minute  => 42,
    require => File['/usr/local/bin/graphite_tarball'],
  }
}
