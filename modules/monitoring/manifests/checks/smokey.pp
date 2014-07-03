# Class: monitoring::checks::smokey
#
# Nagios checks based on Smokey (cucumber HTTP tests). smokey-nagios runs
# periodically and writes the results to a JSON file atomically. That output
# is read by Nagios for each of the check_feature resources.
#
class monitoring::checks::smokey {

  # TODO: Should this really run as root?
  file { '/etc/init/smokey-nagios.conf':
    ensure  => present,
    source  => 'puppet:///modules/monitoring/etc/init/smokey-nagios.conf',
  }

  service { 'smokey-nagios':
    ensure    => running,
    provider  => 'upstart',
    require   => File['/etc/init/smokey-nagios.conf'],
  }

  icinga::check_feature {
    'check_backdrop':               feature => 'backdrop';
    'check_businesssupportfinder':  feature => 'businesssupportfinder';
    'check_calendars':              feature => 'calendars';
    'check_contacts':               feature => 'contacts';
    'check_efg':                    feature => 'efg';
    'check_external_link_tracker':  feature => 'external_link_tracker';
    'check_frontend':               feature => 'frontend';
    'check_licencefinder':          feature => 'licencefinder', notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#licencefinder-smokey-checks';
    'check_licensing':              feature => 'licensing';
    'check_limelight':              feature => 'limelight';
    'check_publishing':             feature => 'mainstream_publishing_tools';
    'check_router':                 feature => 'router';
    'check_search':                 feature => 'search';
    'check_signon':                 feature => 'signon';
    'check_smartanswers':           feature => 'smartanswers';
    'check_spotlight':              feature => 'spotlight';
    'check_static_mirrors':         feature => 'mirror';
    'check_tariff':                 feature => 'tariff';
    'check_whitehall':              feature => 'whitehall';
  }

}
