class govuk::node::jumpbox inherits govuk::node::base {

  include fabric

  file { '/usr/local/share/govuk-fabric':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
  }

}
