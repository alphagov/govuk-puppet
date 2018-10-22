# == Class: govuk::apps::ckan::cronjobs
#
class govuk::apps::ckan::cronjobs {

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

}
