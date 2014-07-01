class govuk::node::s_support_contacts (
  $dump_password,
  $mysql_root_support_contacts,
  $mysql_support_contacts,
  $rotation_daily   = '6',
  $rotation_monthly = '95',
  $rotation_weekly  = '28',
) inherits govuk::node::s_base {

  class { 'govuk_mysql::server':
    root_password => $mysql_root_support_contacts,
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  mysql::db {'support_contacts_production':
    user     => 'support_contacts',
    host     => '%',
    password => $mysql_support_contacts,
  }

  govuk_mysql::user { 'dump@localhost':
    password_hash => mysql_password($dump_password),
    table         => '*.*',
    privileges    => ['SELECT', 'LOCK TABLES', 'SHOW DATABASES'],
  }

  file { '/etc/automysqlbackup/prebackup':
    source => 'puppet:///modules/govuk/etc/automysqlbackup/prebackup',
  }
  file { '/etc/automysqlbackup/postbackup':
    source => 'puppet:///modules/govuk/etc/automysqlbackup/postbackup',
  }
  ensure_packages(['mailutils'])

  include automysqlbackup
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
    mysql_dump_password          => $mysql_root_support_contacts,
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

  Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
  Govuk::Mount['/var/lib/automysqlbackup'] -> Automysqlbackup::Backup['automysqlbackup']
}
