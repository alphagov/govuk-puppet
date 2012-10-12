class govuk_node::jumpbox inherits govuk_node::base {

  include fabric

  file { '/usr/local/share/govuk-fabric':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
  }

}
