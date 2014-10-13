# == Flag whether this machine is safe to reboot
#
# The reason for including separate classes depending on the parameters to
# this class is so that we can use the pre-existing govuk_node_list script
# which accepts a -C argument for a class and prints all the puppet nodes
# known to puppetdb who instantiate that class. Thus to get a list of
# machines that are safe to reboot we can do:
#
#    govuk_node_list -C 'govuk::safe_to_reboot::yes'
#
# [*can_reboot*]
#   Can this machine be rebooted with impunity? ['yes', 'no', 'careful']
#   Default: yes
#
# [*reason*]
#   What is the reasoning for the above state
#   Default: ''
#
class govuk::safe_to_reboot (
  $can_reboot = 'yes',
  $reason = ''
) {
  case $can_reboot {
    'no', 'careful': {
            $reboot_class = "govuk::safe_to_reboot::${can_reboot}"
            if ($reason == '') {
              fail('Machine is flagged as unsafe to reboot, but no reason supplied')
            } else {
              $real_reason = $reason
            }
          }
    'yes': {
            $reboot_class = 'govuk::safe_to_reboot::yes'
            $real_reason = 'Not flagged specifically so assuming safe to reboot'
          }
    default: {
            fail("Invalid value for govuk::safe_to_reboot::can_reboot: ${can_reboot}")
          }
    }

  class { $reboot_class:
      reason => $real_reason,
  }
}
