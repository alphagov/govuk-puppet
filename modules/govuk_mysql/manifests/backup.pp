class govuk_mysql::backup {

  $mysql_backup_username = 'root'
  $mysql_backup_password = hiera('mysql_root','')
  $mysql_backup_host = 'localhost'
  $mysql_backup_email = 'zd-alrt-normal@digital.cabinet-office.gov.uk'

  package { 'automysqlbackup': ensure => installed }

  file { '/etc/default/automysqlbackup':
    owner   => root,
    group   => root,
    require => Package['automysqlbackup'],
    content => template('govuk_mysql/automysqlbackup')
  }
}
