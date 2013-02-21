# Class: rkhunter::update
#
# Ensure that rkhunter definitions get updated when the package is installed
# or the configs updated. Rather than waiting a week for the cron.weekly job
# to fire.
#
class rkhunter::update {
  exec { '/etc/cron.weekly/rkhunter':
    refreshonly => true,
  }
}
