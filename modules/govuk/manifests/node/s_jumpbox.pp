class govuk::node::s_jumpbox inherits govuk::node::s_base {

  file { '/usr/local/share/govuk-fabric':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
  }

}
