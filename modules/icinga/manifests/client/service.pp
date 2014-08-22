# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::client::service {

  service { 'nagios-nrpe-server':
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/nrpe',
  }

}
