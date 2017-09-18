# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::service {

  service { 'icinga':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }

  govuk_logging::logstream { 'icinga_server':
    ensure  => 'present',
    fields  => {'application' => 'icinga'},
    logfile => '/var/log/icinga/icinga.log',
    tags    => ['monitoring', 'icinga'],
    require => Service['icinga'],
  }

  @filebeat::prospector { 'icinga_server':
    ensure  => 'present',
    fields  => {'application' => 'icinga'},
    paths   => ['/var/log/icinga/icinga.log'],
    tags    => ['monitoring', 'icinga'],
    require => Service['icinga'],
  }

}
