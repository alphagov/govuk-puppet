# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class monitoring::client {

  include monitoring::client::apt
  include icinga::client
  include nsca::client
  include auditd
  include collectd

  # Provides:
  # - `notify-reboot-required` which is referenced in the `postinst`
  #   of some packages in order to request that the system be rebooted at a
  #   convenient time. Required by the `check_reboot_required` alert, but
  #   still beneficial to have on nodes that aren't monitored by Nagios.
  # - `apt-check` which is called by the `check_apt_security_updates` alert.
  #   More reliable than the builtin Nagios plugin.
  package {'update-notifier-common': }

  package {'gds-nagios-plugins':
    ensure   => '1.3.0',
    provider => 'pip',
    require  => Package['update-notifier-common']
  }

  class { 'statsd':
    graphite_hostname => 'graphite.cluster',
  }

}
