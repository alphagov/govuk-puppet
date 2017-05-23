# == Class: clamav::cron_freshclam
#
# Update virus database via cron, when the freshclam service is not enabled
#
class clamav::cron_freshclam {
  cron::crondotdee { 'freshclam':
    command => '/usr/bin/freshclam --quiet',
    hour    => '*',
    minute  => '0',
    user    => 'root',
  }
}
