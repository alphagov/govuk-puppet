# == Class: govuk::sshkeys
#
# Add predefined SSH host keys to a machine. These keys are intended to be for
# hosts that a machine will almost always have to connect to.
#
# === Parameters
#
# [*development_keys*]
#   A hash of host keys to seed the development VM. For example keys from preview to
#   allow the data replication script to work without prompting to connect
#   to hosts.
#
class govuk::sshkeys (
  $development_keys = {},
) {
  validate_hash($development_keys)

  $ssh_key_defaults = {
    'type' => 'ssh-rsa',
  }

  create_resources(sshkey, $development_keys, $ssh_key_defaults)

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
  }

  sshkey { 'github.gds':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJsR5gu4+LPnomBEO37hY0l1chnD6U3eA1EHUg/o5op95dal49ZEvVEGtDCWyzwb2AF82/+APwCEHmAGF9l0suG5mU/VvtH4ne+S1Kji0TY+67t5rDDmckC0hqSkBxBrDyHROkXtRIyc/dyyuRhQBgW6zY1bEgM+eobxskWqBbx8bbUhPqH61Bm8fUCegvbgta8YHLKRF2fJ7EMkSXB8ghHQiiWTh1qj7Sz5lUNVGlOwwvXGiVMTLNaTLM+yO/I4Z8+94VkMTkdF4GVP7mn0jx3o84hZ3ZfcKgdD3bWl+e5vLboKb5F4mxMBto85+0F7iI0vnko9mAVHkGKpJjDwf5',
  }
}
