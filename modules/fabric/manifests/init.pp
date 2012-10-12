class fabric {
  package { 'fabric':
    ensure   => 'present',
    provider => 'pip',
  }

  file { '/usr/local/bin/govuk_fab':
    ensure => 'present',
    mode   => '0755',
    source => 'puppet:///modules/fabric/govuk_fab',
  }
}
