class govuk::node::s_mysql_backup inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')

  file { '/etc/automysqlbackup/prebackup':
    source => 'puppet:///modules/govuk/etc/automysqlbackup/prebackup',
  }
  file { '/etc/automysqlbackup/postbackup':
    source => 'puppet:///modules/govuk/etc/automysqlbackup/postbackup',
  }
  ensure_packages(['mailutils'])

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
    mysql_dump_password          => extlookup('mysql_root',''),
    mysql_dump_host              => 'localhost',
    mysql_dump_create_database   => 'yes',
    mysql_dump_use_separate_dirs => 'yes',
    mysql_dump_compression       => 'bzip2',
    mysql_dump_commcomp          => 'no',
    mysql_dump_latest            => 'yes',
    prebackup                    => '/etc/automysqlbackup/prebackup',
    postbackup                   => '/etc/automysqlbackup/postbackup',
    rotation_daily               => extlookup('mysql_backup_rotation_daily','6'),
    rotation_weekly              => extlookup('mysql_backup_rotation_weekly','28'),
    rotation_monthly             => extlookup('mysql_backup_rotation_monthly','95'),
  }

  class { 'mysql::server':
    root_password       => $root_password,
  }
  include mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  if hiera(use_hiera_disks,false) {
    Govuk::Mount['/var/lib/mysql'] -> Class['mysql::server']
  }
}
