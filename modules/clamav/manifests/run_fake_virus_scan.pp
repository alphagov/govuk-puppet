# == Class: clamav::run_fake_virus_scan
#
# Copy uploaded files from the `uploads` folder to the `clean` folder.
# This simulates running a virus scan without the overhead of running
# `clamav` and is used for the development VM. Runs once a minute.
#
class clamav::run_fake_virus_scan {
  cron::crondotdee { 'run_fake_virus_scan':
    command => 'cd /var/apps/whitehall ; /usr/local/bin/govuk_setenv whitehall bundle exec rake development:fake_virus_scan > /dev/null',
    hour    => '*',
    minute  => '*',
    user    => 'vagrant',
  }
}
