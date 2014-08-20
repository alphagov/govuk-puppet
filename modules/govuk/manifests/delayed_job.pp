# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::delayed_job {
  # One word of caution: this is a generic worker that runs a Rake task,
  # rather than necessarily being tied to the `delayed_job` library.

  file { '/usr/local/bin/govuk_run_delayed_job_worker':
    ensure => present,
    source => 'puppet:///modules/govuk/bin/govuk_run_delayed_job_worker',
    mode   => '0755',
  }
}
