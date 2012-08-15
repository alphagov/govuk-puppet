class ganglia {
  anchor {:'ganglia::start','ganglia::end']: }
  include ganglia::uninstall_old, ganglia::package, ganglia::config, ganglia::service

  Anchor['ganglia::start'] -> Class['ganglia::uninstall_old'] -> Class['ganglia::package'] -> Class['ganglia::config'] ~> Class['ganglia::service'] ~> Anchor['ganglia::end']
  Class['ganglia::package'] ~> Class['ganglia::service']
}
