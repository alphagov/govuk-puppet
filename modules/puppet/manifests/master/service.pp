class puppet::master::service {
  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/puppetmaster.conf'],
    restart  => '/sbin/initctl reload puppetmaster',
  }
}
