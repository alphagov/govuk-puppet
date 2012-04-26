class mysql::backup {
  package { 'automysqlbackup': ensure => installed }
  file { '/etc/default/automysqlbackup':
    owner   => root,
    group   => root,
    require => Package['automysqlbackup'],
    source  => 'puppet:///modules/mysql/automysqlbackup'
  }
}
