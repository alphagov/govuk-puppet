class duplicity {
  package { 'duplicity':
    ensure => 'installed'
  }
  file { '/etc/cron.hourly/duplicity':
    ensure => present,
    source => 'puppet:///modules/duplicity/hourly.duplicity.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0655',
  }
}
