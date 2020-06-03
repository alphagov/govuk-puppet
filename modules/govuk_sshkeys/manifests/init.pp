# == Class: govuk_sshkeys
#
# Add predefined SSH host keys to a machine. These keys are intended to be for
# hosts that a machine will almost always have to connect to.
#
# === Parameters
#
# [*deployment_keys*]
#   A hash of host keys that are used for deploying software from source control.
#
class govuk_sshkeys (
  $deployment_keys = {},
) {
  validate_hash($deployment_keys)

  $ssh_key_defaults = {
    'type' => 'ssh-rsa',
  }

  create_resources(sshkey, $deployment_keys, $ssh_key_defaults)
}
