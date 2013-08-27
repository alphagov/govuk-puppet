# == Class: clamav::run_freshclam
#
# Run freshclam after a new install in order to populate the databases that
# clamav-daemon needs to run. This enables the service to start in the same
# Puppet run as the package install. If it fails, then the freshclam daemon
# should have run by the time Puppet next attempts to start clamav-daemon.
#
class clamav::run_freshclam {
  exec { 'freshclam --quiet':
    refreshonly => true,
  }
}
