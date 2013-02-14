class nginx::package {

  include govuk::ppa

  # FIXME: https://www.pivotaltracker.com/story/show/44377213
  # See `modules/router/templates/base.conf.erb` before upgrading.
  case $::lsbdistcodename {
    'precise': {
      $version = '1.2.4-2ubuntu0ppa1~precise'
    }
    default: {
      $version = '1.2.4-2ubuntu0ppa4~lucid'
    }
  }

  package { 'nginx':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

}
