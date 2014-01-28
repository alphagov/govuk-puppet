class govuk::node::s_jumpbox inherits govuk::node::s_base {

  #REMOVE: once its been pushed out.
  file { '/usr/local/share/govuk-fabric':
    ensure => 'absent',
  }

}
