class ganglia {
  include ganglia::uninstall_old, ganglia::package, ganglia::config, ganglia::service
}
