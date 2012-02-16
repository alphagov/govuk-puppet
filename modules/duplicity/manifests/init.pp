class duplicity {
  package { "duplicity":
    ensure => "installed"
  }
  file { "/etc/cron.hourly/duplicity":
    source => 'puppet:///modules/duplicity/hourly.duplicity.sh',
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '655',
  }
}
