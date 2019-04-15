# == Class: puppet::cronjob
#
# Sets up a cronjob that runs Puppet periodically.
#
# === Parameters
#
# [*enabled*]
#   Boolean, whether or not the cronjob should be created.
#
class puppet::cronjob (
  $enabled = true,
) {

  if $enabled {
    if ((! $::aws_migration) and ($::fqdn =~ /^puppetmaster/)) or
      (($::aws_migration) and ($::aws_migration =~ /^puppetmaster/)) {
      $first_run = 0
      $second_run = 30
    } else {
      $first_run = 5 + fqdn_rand(21)
      $second_run = 35 + fqdn_rand(21)
    }

    cron { 'puppet':
      ensure  => present,
      user    => 'root',
      minute  => [$first_run, $second_run],
      command => '/usr/local/bin/govuk_puppet',
      require => File['/usr/local/bin/govuk_puppet'],
    }
  }
}
