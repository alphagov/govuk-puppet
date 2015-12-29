# == Class: govuk::sshkeys
#
# Add predefined SSH host keys to a machine. These keys are intended to be for
# hosts that a machine will almost always have to connect to.
#
# === Parameters
#
# [*deployment_keys*]
#   A hash of host keys that are used for deploying software from source control.
#
# [*development_keys*]
#   A hash of host keys to seed the development VM. For example keys from a live environment to
#   allow the data replication script to work without prompting to connect
#   to hosts.
#
class govuk::sshkeys (
  $deployment_keys = {},
  $development_keys = {},
) {
  validate_hash($deployment_keys, $development_keys)

  $ssh_key_defaults = {
    'type' => 'ssh-rsa',
  }

  create_resources(sshkey, $deployment_keys, $ssh_key_defaults)
  create_resources(sshkey, $development_keys, $ssh_key_defaults)

}
