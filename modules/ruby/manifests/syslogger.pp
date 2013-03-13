class ruby::syslogger {
  package { 'syslogger':
    ensure   => present,
    provider => 'gem',
  }
}
