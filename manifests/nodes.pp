# Top-level variable also used by `hiera.yml`.
# Cannot be spoofed by Facter from `puppet agent`.
$govuk_node_class = govuk_node_class()

node default {
  # This will fail with an error if the node class doesn't exist.
  class { "govuk::node::s_${::govuk_node_class}": }

  #FIXME: when we have moved off interim platform remove the if statement
  if hiera(use_hiera_disks, false) {
    $lv = hiera('lv',{})
    create_resources('govuk::lvm', $lv)
    $mount = hiera('mount',{})
    create_resources('govuk::mount', $mount)
  }
}
