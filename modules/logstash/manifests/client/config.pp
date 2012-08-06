class logstash::client::config {
  include logstash::config
  file { '/etc/logstash/logstash-client' :
    ensure  => directory,
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
    require => File['/etc/logstash']
  }

  file { '/etc/logstash/logstash-client/default.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-client/default.conf',
    require => File['/etc/logstash/logstash-client']
  }
}
