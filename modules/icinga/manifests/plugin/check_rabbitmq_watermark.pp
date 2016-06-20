# == Class: icinga::plugin::check_rabbitmq_watermark
#
# Install a Nagios plugin that alerts when rabbitmq watermark
# is exceeded
#

class icinga::plugin::check_rabbitmq_watermark {

  @icinga::plugin { 'check_rabbitmq_watermark':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_rabbitmq_watermark',
  }

  @icinga::nrpe_config { 'check_rabbitmq_watermark':
    content => template('govuk_rabbitmq/check_rabbitmq_watermark.cfg.erb'),
    require => Icinga::Plugin['check_rabbitmq_watermark'],
  }

  ensure_packages(['libnagios-plugin-perl', 'libjson-perl', 'libwww-perl'])
}
