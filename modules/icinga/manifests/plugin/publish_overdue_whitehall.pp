# == Class: icinga::plugin::publish_overdue_whitehall
#
# Install a Nagios plugin that can be triggered to publish overdue Whitehall documents.
#
class icinga::plugin::publish_overdue_whitehall () {

  @icinga::plugin { 'publish_overdue_whitehall':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/publish_overdue_whitehall',
  }

  @icinga::nrpe_config { 'publish_overdue_whitehall':
    content  => template('icinga/etc/nagios/nrpe.d/publish_overdue_whitehall.cfg.erb'),
  }

}
