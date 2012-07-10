class graphite::package {
  package{['python-flup', 'python-carbon', 'python-graphite-web', 'python-txamqp', 'python-whisper']:
    ensure => present,
  }
}