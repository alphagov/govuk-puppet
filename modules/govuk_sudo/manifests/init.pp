# == Class: govuk_sudo
#
# A thin wrapper for the upstream 'sudo' module.
#
# === Examples
#
# To add a configuration snippet using Hiera:
#
# govuk_sudo::sudo_conf:
#   snippet_name:
#     content: 'foo ALL=(ALL:ALL) ALL'
#
class govuk_sudo ()
{

  # Configure upstream module to use the sudoers file provided by govuk_sudo
  class { 'sudo':
    source => 'puppet:///modules/govuk_sudo/sudoers'
  }

  # FIXME: Remove hiera_hash and use automatic parameter lookups
  # once this bug in Hiera is fixed:
  # https://tickets.puppetlabs.com/browse/HI-118
  $sudoers_d_snippets = hiera_hash('govuk_sudo::sudo_conf', {})

  # Check for a valid hash; sudoers syntax is validated by the upstream module
  validate_hash($sudoers_d_snippets)

  # Create sudoers.d snippets using upstream 'sudo' module
  create_resources('sudo::conf', $sudoers_d_snippets)
}
