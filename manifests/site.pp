Exec { path => '/usr/lib/rbenv/shims:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' }

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

# Default destination address to 'any' instead of the default `$::ipaddress`
# in order to support nodes with multiple interfaces such as Vagrant.
Ufw::Allow {
  ip  => 'any',
}

# Ensure update is always run before any package installs.
# title conditions prevent a dependency loop within apt module.
Class['apt::update'] -> Package <|
  provider != pip and
  provider != gem and
  provider != system_gem and
  ensure != absent and
  ensure != purged and
  title != 'python-software-properties' and
  title != 'software-properties-common' and
  tag != 'no_require_apt_update'
|>

# Top-level variable also used by `hiera.yml`.
# Cannot be spoofed by Facter from `puppet agent`.
$govuk_node_class = govuk_node_class()

if chomp(hiera('HIERA_EYAML_GPG_CHECK')) != "It's all OK penguins" {
  fail("Hiera eYAML GPG encryption backend is not working; you should read: \
https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/infrastructure/howto/encrypted-hiera-data.html?#puppet-fails-because-my-it-can-t-find-a-usable-gpg-key")
}

node default {
  govuk_check_hostname_facts()

  # This will fail with an error if the node class doesn't exist.
  class { "govuk::node::s_${::govuk_node_class}": }


  # Create logical volumes from hiera
  $lv = hiera('lv',{})
  create_resources('govuk_lvm', $lv)
  # Create mounts from hiera
  $mount = hiera('mount',{})
  create_resources('govuk_mount', $mount)
}
