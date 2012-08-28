class puppet::master::service {
  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    restart  => '/sbin/initctl reload puppetmaster',
  }
}
