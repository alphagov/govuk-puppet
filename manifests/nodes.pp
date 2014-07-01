# Top-level variable also used by `hiera.yml`.
# Cannot be spoofed by Facter from `puppet agent`.
$govuk_node_class = govuk_node_class()

node default {
  if $::lsbdistcodename == 'lucid' {
    fail('Ubuntu Lucid is no longer supported')
  }

  govuk_check_hostname_facts()

  # This will fail with an error if the node class doesn't exist.
  class { "govuk::node::s_${::govuk_node_class}": }


  # Create logical volumes from hiera
  $lv = hiera('lv',{})
  create_resources('govuk::lvm', $lv)
  # Create mounts from hiera
  $mount = hiera('mount',{})
  create_resources('govuk::mount', $mount)
}
