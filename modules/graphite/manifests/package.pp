class graphite::package {
  include govuk::repository
  package{['python-flup', 'python-carbon', 'python-graphite-web', 'python-txamqp', 'python-whisper']:
    ensure  => present,
    require => Apt::Deb_repository['gds']
  }
}