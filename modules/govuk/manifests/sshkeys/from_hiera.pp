# == Class: govuk::sshkeys::from_hiera
#
# Adds some predefined ssh host keys from hiera.  This is intended to seed the
# dev VM with ssh keys from preview to allow the replicate-data-local script to
# work without prompting for each host it connects to.
class govuk::sshkeys::from_hiera (
  $keys = {},
) {
  Sshkey {
    type => 'ssh-rsa',
  }

  create_resources(sshkey, $keys)
}
