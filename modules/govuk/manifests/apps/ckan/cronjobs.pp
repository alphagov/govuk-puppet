# == Class: govuk::apps::ckan::cronjobs
#
# [*ckan_port*]
#   The port CKAN is running on.
#
# [*pycsw_config*]
#   The location of the PyCSW configuration file.
#
# [*enable*]
#   Allows disabling of all ckan cronjobs
#   Default: true
#
# [*enable_solr_reindex*]
#   Enable automatic Solr reindexing, this is useful to run after the data
#   sync. Requires $enable to be true.
#   Default: false
#
class govuk::apps::ckan::cronjobs(
  $ckan_port,
  $pycsw_config,
  $enable              = false,
  $enable_solr_reindex = false,
) {
  if ($enable_solr_reindex and !$enable) {
    fail "Can't \$enable_solr_reindex without \$enable"
  }

  $ensure = $enable ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::apps::ckan::ckan_cronjob { 'Find a Tender harvester stop existing processes':
    ensure       => $ensure,
    ckan_command => 'harvester job-abort find-tender-data-harvest',
    hour         => '2',
    minute       => '25',
  }

  govuk::apps::ckan::ckan_cronjob { 'Find a Tender harvester run':
    ensure       => $ensure,
    ckan_command => 'harvester run-test find-tender-data-harvest',
    hour         => '2',
    minute       => '30',
  }

  govuk::apps::ckan::ckan_cronjob { 'Contract Finder harvester stop existing processes':
    ensure       => $ensure,
    ckan_command => 'harvester job-abort contracts-finder-ocds-data-harvest',
    hour         => '5',
    minute       => '25',
  }

  govuk::apps::ckan::ckan_cronjob { 'Contract Finder harvester run':
    ensure       => $ensure,
    ckan_command => 'harvester run-test contracts-finder-ocds-data-harvest',
    hour         => '5',
    minute       => '30',
  }

  govuk::apps::ckan::ckan_cronjob { 'Environment Agency harvester stop existing processes':
    ensure       => 'absent',
    ckan_command => 'harvester job-abort environment-agency-data-sharing-platform',
    weekday      => '5',
    hour         => '15',
    minute       => '55',
  }

  govuk::apps::ckan::ckan_cronjob { 'Environment Agency harvester run':
    ensure       => 'absent',
    ckan_command => 'harvester run-test environment-agency-data-sharing-platform',
    weekday      => '5',
    hour         => '16',
    minute       => '0',
  }

  govuk::apps::ckan::ckan_cronjob { 'Vale of White Horse harvester stop existing processes':
    ensure       => $ensure,
    ckan_command => 'harvester job-abort vale-of-white-horse-district-council-2',
    weekday      => '5',
    hour         => '16',
    minute       => '10',
  }

  govuk::apps::ckan::ckan_cronjob { 'Vale of White Horse harvester run':
    ensure       => $ensure,
    ckan_command => 'harvester run-test vale-of-white-horse-district-council-2',
    weekday      => '5',
    hour         => '16',
    minute       => '15',
  }

  govuk::apps::ckan::ckan_cronjob { 'South Oxfordshire harvester stop existing processes':
    ensure       => $ensure,
    ckan_command => 'harvester job-abort south-oxfordshire-district-council-2',
    weekday      => '5',
    hour         => '16',
    minute       => '25',
  }

  govuk::apps::ckan::ckan_cronjob { 'South Oxfordshire harvester run':
    ensure       => $ensure,
    ckan_command => 'harvester run-test south-oxfordshire-district-council-2',
    weekday      => '5',
    hour         => '16',
    minute       => '30',
  }

  govuk::apps::ckan::ckan_cronjob { 'harvester run':
    ensure       => $ensure,
    ckan_command => 'harvester run',
    minute       => '*/5',
    # timeout shorter than repeat period to prevent stalling runs stacking up
    timeout      => '4m',
  }

  govuk::apps::ckan::ckan_cronjob { 'harvester cleanup':
    ensure       => $ensure,
    ckan_command => 'harvester clean-harvest-log',
    hour         => '2',
  }

  $ensure_solr_reindex = $enable_solr_reindex ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::apps::ckan::ckan_cronjob { 'index missing packages':
    ensure       => $ensure_solr_reindex,
    ckan_command => 'search-index rebuild -o',
    hour         => '4',
    minute       => '0',
  }

  govuk::apps::ckan::ckan_cronjob { 'pycsw load':
    ensure       => $ensure,
    ckan_command => "ckan-pycsw load -p ${pycsw_config} -u http://localhost:${ckan_port}",
    hour         => '6',
    minute       => '0',
    ckan_ini     => false,
  }
}
