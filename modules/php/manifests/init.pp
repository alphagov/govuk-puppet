# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class php {

  include govuk::ppa

  package { 'php5-fpm':
    ensure => present,
    notify => Service['php5-fpm'],
  }

  package { 'php5-cli':
    ensure => present,
  }

  file { '/etc/php5/fpm/pool.d/www.conf':
    ensure  => present,
    require => Package['php5-fpm'],
    notify  => Service['php5-fpm'],
    source  => 'puppet:///modules/php/www.conf',
  }

  service { 'php5-fpm':
    ensure    => running,
    hasstatus => false,
    pattern   => 'php-fpm',
  }

}
