# == Class: backup::mysql
#
# Perform local backups of MySQL data.
#
# === Parameters
#
# [*mysql_dump_password*]
#   Passed straight through to automysqlbackup::backup
#
# [*rotation_daily*]
#   Passed straight through to automysqlbackup::backup
#
# [*rotation_weekly*]
#   Passed straight through to automysqlbackup::backup
#
# [*rotation_monthly*]
#   Passed straight through to automysqlbackup::backup
#
# [*mysql_dump_host*]
#   The host to dump databases from
#
class backup::mysql (
  $mysql_dump_password,
  $rotation_daily = '6',
  $rotation_weekly = '28',
  $rotation_monthly = '95',
  $mysql_dump_host = 'localhost',
) {
  validate_string($rotation_daily, $rotation_weekly, $rotation_monthly)

  $threshold_secs = 28 * (60 * 60)
  $service_desc   = 'automysqlbackup'

  file { '/etc/automysqlbackup/prebackup':
    source => 'puppet:///modules/backup/etc/automysqlbackup/prebackup',
  }
  file { '/etc/automysqlbackup/postbackup':
    content => template('backup/etc/automysqlbackup/postbackup.erb'),
  }

  @@icinga::passive_check { "check_automysqlbackup-${::hostname}":
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
    action_url          => "https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.carrenza/${::hostname}\$20duplicity%7Csort:date",
    notes_url           => monitoring_docs_url(backup-passive-checks),
  }

  ensure_packages(['mailutils'])

  include ::automysqlbackup
  automysqlbackup::backup { 'automysqlbackup':
    backup_dir                   => '/var/lib',
    backup_dir_perms             => '0755',
    backup_file_perms            => '0444',
    db_exclude                   => ['mysql', 'information_schema', 'performance_schema', 'test'],
    do_weekly                    => '6',
    mail_address                 => 'root',
    mailcontent                  => 'quiet',
    mail_maxattsize              => '4000',
    mysql_dump_username          => 'root',
    mysql_dump_password          => $mysql_dump_password,
    mysql_dump_host              => $mysql_dump_host,
    mysql_dump_create_database   => 'yes',
    mysql_dump_use_separate_dirs => 'yes',
    mysql_dump_compression       => 'bzip2',
    mysql_dump_commcomp          => 'no',
    mysql_dump_latest            => 'yes',
    prebackup                    => '/etc/automysqlbackup/prebackup',
    postbackup                   => '/etc/automysqlbackup/postbackup',
    rotation_daily               => $rotation_daily,
    rotation_weekly              => $rotation_weekly,
    rotation_monthly             => $rotation_monthly,
  }
}
