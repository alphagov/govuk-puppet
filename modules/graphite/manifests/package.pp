class graphite::package {
  include apt

  apt::deb_repository { 'ubuntuus':
    url     => 'http://us.archive.ubuntu.com/ubuntu',
    dist    => 'lucid',
    repo    => 'multiverse',
  }

  package{['python-flup', 'python-carbon', 'python-graphite-web', 'python-txamqp', 'python-whisper', 'libapache2-mod-fastcgi']:
    ensure  => present,
    require => Apt::Deb_repository['ubuntuus'];
  }
}
