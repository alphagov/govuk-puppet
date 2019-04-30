# == Class: govuk::apps::ckan::cronjobs
#
# [*enable_solr_reindex*]
#   Enable automatic Solr reindexing, this is useful to run after the data
#   sync.
#   Default: false
#
class govuk::apps::ckan::cronjobs(
  $enable_solr_reindex = false,
) {

  govuk::apps::ckan::paster_cronjob { 'harvester run':
    paster_command => 'harvester run',
    plugin         => 'ckanext-harvest',
    minute         => '*/5',
  }

  govuk::apps::ckan::paster_cronjob { 'harvester cleanup':
    paster_command => 'harvester clean_harvest_log',
    plugin         => 'ckanext-harvest',
    hour           => '2',
  }

  $ensure_solr_reindex = $enable_solr_reindex ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::apps::ckan::paster_cronjob { 'harvester reindex':
    ensure         => $ensure_solr_reindex,
    paster_command => 'search-index rebuild -o',
    plugin         => 'ckan',
    hour           => '7',
    minute         => '0',
  }

}
