# == Class: rkhunter::monitoring
#
# Nagios check to ensure that the definition update has been run by the
# weekly cronjob. This is subtley different from checking that the
# definitions have actually been updated, but it's the best we can do
# because:
#
# - The `--versioncheck` argument only checks the installed version of
#   rkhunter (which comes from Ubuntu packages) and not the updates.
# - The `--update` argument will provide information about updates. But it's
#   not idempotent, in the respect that it will also trigger the update.
# - The actual definition files don't update often enough to second guess
#   their frequency. Some for version 1.3 are currently 2 years old.
#
# The mirrors database does get updated on every run, so we use it's mtime
# as an indication whether the cronjob has been running. To avoid using sudo
# we give the nagios user read permissions on the DB directory so that it
# can stat() the files within. There is a dependency on icinga::client for
# the creation of that GID.
#
class rkhunter::monitoring {
  file { '/var/lib/rkhunter/db':
    ensure  => directory,
    owner   => 'root',
    group   => 'nagios',
    mode    => '0750',
    require => Class['icinga::client'],
  }

  file { '/var/lib/rkhunter/db/mirrors.dat':
    owner   => root,
    group   => nagios,
    mode    => '0644',
    require => Class['icinga::client'],
  }

  # Convert days to seconds.
  $warning_age = 8 * (24 * 60 * 60)

  @@icinga::check { "check_rkhunter_definitions_${::hostname}":
    check_command       => "check_nrpe!check_file_age!\"-f /var/lib/rkhunter/db/mirrors.dat -c0 -w${warning_age}\"",
    service_description => 'rkhunter definitions not updated',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(rkhunter-warnings),
  }

  # Script to run rkhunter as a passive check
  file { '/usr/local/bin/rkhunter-passive-check':
    ensure  => present,
    mode    => '0755',
    content => template('rkhunter/rkhunter-passive-check.erb'),
  }

  # Run it twice a day to stop superfluous alerting
  cron::crondotdee { 'rkhunter-passive-check':
    command => '/usr/local/bin/rkhunter-passive-check',
    hour    => '6,14',
    minute  => '0',
  }

  @@icinga::passive_check { "check_rkhunter_${::hostname}":
    service_description => 'rkhunter warnings',
    host_name           => $::fqdn,
    # 26 hours (cron should run daily, with some leeway)
    freshness_threshold => 93600,
    notes_url           => monitoring_docs_url(rkhunter-warnings),
    require             => File['/etc/cron.d/rkhunter-passive-check'],
  }

}
