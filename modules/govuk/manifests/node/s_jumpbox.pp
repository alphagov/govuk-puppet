# == Class: govuk::node::s_jumpbox
#
# Configures an SSH jumpbox, also known as a bastion host
#
class govuk::node::s_jumpbox inherits govuk::node::s_base {
  include govuk_unattended_reboot::jumpbox
}
