class govuk::node::s_jumpbox inherits govuk::node::s_base {

  # FIXME: When deployed to preview (platform1 never got this).
  file { '/usr/local/share/govuk-fabric':
    ensure  => absent,
    recurse => true,
    force   => true,
    backup  => false,
  }

}
