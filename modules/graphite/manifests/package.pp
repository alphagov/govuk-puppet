class graphite::package {
  include govuk::repository
  package{['python-flup', 'python-carbon', 'python-graphite-web', 'python-txamqp', 'python-whisper', 'libapache2-mod-fastcgi']:
    ensure  => present,
    require => Apt::Deb_repository['gds']
  }
}