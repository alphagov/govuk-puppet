# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_jenkins::master inherits govuk_jenkins {

  $app_domain = hiera('app_domain')

  apt::source { 'jenkins':
    location     => 'http://apt.production.alphagov.co.uk/jenkins',
    release      => 'binary',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }

  package { 'jenkins':
    ensure  => '1.554.2',
    require => Class['govuk_jenkins'],
  }

  file { '/etc/default/jenkins':
    ensure  => file,
    source  => 'puppet:///modules/govuk_jenkins/etc/default/jenkins',
    require => Package['jenkins'],
  }

  service { 'jenkins':
    ensure    => 'running',
    subscribe => File['/etc/default/jenkins'],
  }

  # FIXME: Remove when deployed.
  file { '/var/govuk-archive':
    ensure => absent,
    force  => true,
  }
}
