# == set environment variable based on rebootability
#
#  [*reason*]
#  Why is this machine flagged as this rebootability
#
class govuk::safe_to_reboot::no (
  $reason,
) {
  govuk::envvar { 'SAFE_TO_REBOOT':
    value => 'no',
  }
  govuk::envvar { 'SAFE_TO_REBOOT_REASON':
    value => $reason,
  }
}
