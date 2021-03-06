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
  $enable              = true,
  $enable_solr_reindex = false,
) {
  if ($enable_solr_reindex and !$enable) {
    fail "Can't \$enable_solr_reindex without \$enable"
  }

  $ensure = $enable ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::apps::ckan::paster_cronjob { 'harvester run':
    ensure         => $ensure,
    paster_command => 'harvester run',
    plugin         => 'ckanext-harvest',
    minute         => '*/5',
    # timeout shorter than repeat period to prevent stalling runs stacking up
    timeout        => '4m',
  }

  govuk::apps::ckan::paster_cronjob { 'harvester cleanup':
    ensure         => $ensure,
    paster_command => 'harvester clean_harvest_log',
    plugin         => 'ckanext-harvest',
    hour           => '2',
  }

  $ensure_solr_reindex = $enable_solr_reindex ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::apps::ckan::paster_cronjob { 'index missing packages':
    ensure         => $ensure_solr_reindex,
    paster_command => 'search-index rebuild -o',
    plugin         => 'ckan',
    hour           => '4',
    minute         => '0',
  }

  govuk::apps::ckan::paster_cronjob { 'pycsw load':
    ensure         => $ensure,
    paster_command => "ckan-pycsw load -p ${pycsw_config} -u http://localhost:${ckan_port}",
    plugin         => 'ckanext-spatial',
    hour           => '6',
    minute         => '0',
    ckan_ini       => false,
  }
}
