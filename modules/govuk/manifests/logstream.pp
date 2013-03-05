class govuk::logstream {

  file { '/etc/init/logstream.conf':
    source => 'puppet:///modules/govuk/etc/logstream.conf',
  }

}
