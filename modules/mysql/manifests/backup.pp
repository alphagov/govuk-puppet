class mysql::backup {
  /* Automated RDS backup for loading into dev/preview boxen */
  $mysql_backup_username = 'backup'
  $mysql_backup_password = extlookup('mysql_backup')
  $mysql_backup_host = 'rds.cluster'
  $mysql_backup_email = 'govuk-dev@digital.cabinet-office.gov.uk'

  package { 'automysqlbackup': ensure => installed }
  file { '/etc/default/automysqlbackup':
    owner   => root,
    group   => root,
    require => Package['automysqlbackup'],
    content => template('mysql/automysqlbackup')
  }
}
