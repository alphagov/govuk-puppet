# == Class: govuk_monit
#
# Install and run Monit process supervisor
#
#
class govuk_monit(
) {
  package { 'monit':
    ensure  => latest,
  }

  @@icinga::check { "check_monit_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!monit',
    service_description => 'monit running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
