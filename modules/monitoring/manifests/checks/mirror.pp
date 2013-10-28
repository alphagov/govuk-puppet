# == Class: monitoring::checks::mirror
#
# Nagios alerts for Mirror staleness.
#
class monitoring::checks::mirror {
  $mirror_subdomain = 'mirror.provider0.production.govuk.service.gov.uk'
  $mirror_vhost     = "www-origin.${mirror_subdomain}"

  nagios::check_config { 'mirror_age':
    source => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_mirror_age.cfg',
  }

  nagios::check { 'check_mirror0_up_to_date':
    check_command       => "check_mirror_age!mirror0.${mirror_subdomain}!${mirror_vhost}",
    host_name           => $::fqdn,
    service_description => 'mirror0 site out of date',
  }

  nagios::check { 'check_mirror1_up_to_date':
    check_command       => "check_mirror_age!mirror1.${mirror_subdomain}!${mirror_vhost}",
    host_name           => $::fqdn,
    service_description => 'mirror1 site out of date',
  }
}
