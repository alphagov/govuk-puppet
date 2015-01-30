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
class backup::mysql (
  $mysql_dump_password,
  $rotation_daily = 6,
  $rotation_weekly = 28,
  $rotation_monthly = 95,
) {
  file { '/etc/automysqlbackup/prebackup':
    source => 'puppet:///modules/backup/etc/automysqlbackup/prebackup',
  }
  file { '/etc/automysqlbackup/postbackup':
    source => 'puppet:///modules/backup/etc/automysqlbackup/postbackup',
  }

  ensure_packages(['mailutils'])

  include ::automysqlbackup
  automysqlbackup::backup { 'automysqlbackup':
    backup_dir                   => '/var/lib',
    backup_dir_perms             => '0755',
    backup_file_perms            => '0444',
    db_exclude                   => ['mysql', 'information_schema', 'performance_schema', 'test'],
    do_weekly                    => '6',
    mail_address                 => 'zd-alrt-normal@digital.cabinet-office.gov.uk',
    mailcontent                  => 'quiet',
    mail_maxattsize              => '4000',
    mysql_dump_username          => 'root',
    mysql_dump_password          => $mysql_dump_password,
    mysql_dump_host              => 'localhost',
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
