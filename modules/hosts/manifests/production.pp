# == Class: hosts::production
#
# Manage /etc/hosts entries for various machines
#
# these are real hosts (1-1 mapping between host and service) anything that
# ends .cluster is maintained for backwards compatibility with ec2
#
# === Parameters:
#
# [*apt_mirror_internal*]
#   Point `apt.production.alphagov.co.uk` to `apt-1` within this
#   environment. Instead of going to the Production VSE.
#   Default: false
#
class hosts::production (
  $apt_mirror_internal    = false,
  $releaseapp_host_org    = false,
  $ip_bouncer             = '127.0.0.1',
  $ip_redirector          = '127.0.0.1',
) {

  $app_domain = hiera('app_domain')
  $internal_tld = hiera('internal_tld', 'production')

  validate_bool($apt_mirror_internal)
  $apt_aliases = $apt_mirror_internal ? {
    true    => ['apt.production.alphagov.co.uk'],
    default => undef,
  }

  #management vdc machines
  govuk::host { 'jenkins-1':
    ip             => '10.0.0.3',
    vdc            => 'management',
  }
  govuk::host { 'puppetmaster-1':
    ip              => '10.0.0.5',
    vdc             => 'management',
    legacy_aliases  => ['puppet'],
    service_aliases => ['puppet', 'puppetdb'],
  }

  govuk::host { 'monitoring-1':
    ip              => '10.0.0.20',
    vdc             => 'management',
    legacy_aliases  => ['monitoring', "nagios.${app_domain}"],
    service_aliases => ['alert', 'monitoring', 'nagios'],
  }

  govuk::host { 'graphite-1':
    ip              => '10.0.0.22',
    vdc             => 'management',
    legacy_aliases  => ["graphite.${app_domain}"],
    service_aliases => ['graphite'],
  }
  govuk::host { 'logs-cdn-1':
    ip              => '10.0.0.27',
    vdc             => 'management',
  }
  govuk::host { 'logging-1':
    ip              => '10.0.0.28',
    vdc             => 'management',
    service_aliases => ['logging'],
  }
  govuk::host { 'logs-elasticsearch-1':
    ip              => '10.0.0.29',
    vdc             => 'management',
    service_aliases => ['logs-elasticsearch'],
  }
  govuk::host { 'logs-elasticsearch-2':
    ip              => '10.0.0.30',
    vdc             => 'management',
  }
  govuk::host { 'logs-elasticsearch-3':
    ip              => '10.0.0.31',
    vdc             => 'management',
  }
  govuk::host { 'logs-redis-1':
    ip             => '10.0.0.40',
    vdc            => 'management',
  }
  govuk::host { 'logs-redis-2':
    ip             => '10.0.0.41',
    vdc            => 'management',
  }
  govuk::host { 'backup-1':
    ip              => '10.0.0.50',
    vdc             => 'management',
  }
  govuk::host { 'apt-1':
    ip              => '10.0.0.75',
    vdc             => 'management',
    legacy_aliases  => $apt_aliases,
    service_aliases => ['apt'],
  }
  govuk::host { 'jumpbox-1':
    ip              => '10.0.0.100',
    vdc             => 'management',
  }
  govuk::host { 'mirrorer-1':
    ip             => '10.0.0.128',
    vdc            => 'management',
  }
  govuk::host { 'jumpbox-2':
    ip              => '10.0.0.200',
    vdc             => 'management',
  }

  #router vdc machines
  govuk::host { 'cache-1':
    ip              => '10.1.0.2',
    vdc             => 'router',
  }
  govuk::host { 'cache-2':
    ip              => '10.1.0.3',
    vdc             => 'router',
  }
  govuk::host { 'cache-3':
    ip              => '10.1.0.4',
    vdc             => 'router',
  }
  govuk::host { 'router-backend-1':
    ip             => '10.1.0.10',
    vdc            => 'router',
  }
  govuk::host { 'router-backend-2':
    ip             => '10.1.0.11',
    vdc            => 'router',
  }
  govuk::host { 'router-backend-3':
    ip             => '10.1.0.12',
    vdc            => 'router',
  }

  #router lb vhosts
  govuk::host { 'cache':
    ip              => '10.1.1.1',
    vdc             => 'router',
    legacy_aliases  => [
      'cache',
      "www.${app_domain}",
      "www-origin.${app_domain}",
      "assets-origin.${app_domain}",
    ],
    service_aliases => ['cache', 'router'],
  }
  govuk::host { 'router-backend-internal-lb':
    ip              => '10.1.1.2',
    vdc             => 'router',
    legacy_aliases  => ["router-api.${app_domain}"],
  }

  #frontend vdc machines
  govuk::host { 'calculators-frontend-1':
    ip             => '10.2.0.11',
    vdc            => 'frontend',
  }
  govuk::host { 'calculators-frontend-2':
    ip             => '10.2.0.12',
    vdc            => 'frontend',
  }
  govuk::host { 'calculators-frontend-3':
    ip             => '10.2.0.13',
    vdc            => 'frontend',
  }
  govuk::host { 'frontend-1':
    ip             => '10.2.0.2',
    vdc            => 'frontend',
  }
  govuk::host { 'frontend-2':
    ip             => '10.2.0.3',
    vdc            => 'frontend',
  }
  govuk::host { 'frontend-3':
    ip             => '10.2.0.4',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-1':
    ip             => '10.2.0.5',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-2':
    ip             => '10.2.0.6',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-3':
    ip             => '10.2.0.10',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-4':
    ip             => '10.2.0.14',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-5':
    ip             => '10.2.0.15',
    vdc            => 'frontend',
  }

  #frontend lb vhosts
  govuk::host { 'frontend-lb-1':
    ip             => '10.2.0.101',
    vdc            => 'frontend',
  }
  govuk::host { 'frontend-lb-2':
    ip             => '10.2.0.102',
    vdc            => 'frontend',
  }
  govuk::host { 'frontend-internal-lb':
    ip             => '10.2.1.2',
    vdc            => 'frontend',
    legacy_aliases => [
      "businesssupportfinder.${app_domain}",
      "calculators.${app_domain}",
      "calendars.${app_domain}",
      "canary-frontend.${app_domain}",
      "collections.${app_domain}",
      "contacts-frontend.${app_domain}",
      "contacts-frontend-old.${app_domain}",
      "designprinciples.${app_domain}",
      "feedback.${app_domain}",
      "finder-frontend.${app_domain}",
      "frontend.${app_domain}",
      "furl-manager.${app_domain}",
      "manuals-frontend.${app_domain}",
      "licencefinder.${app_domain}",
      "limelight.${app_domain}",
      "publicapi.${app_domain}",
      "public-link-tracker.${app_domain}",
      "service-manual.${app_domain}",
      "smartanswers.${app_domain}",
      "spotlight.${app_domain}",
      "specialist-frontend.${app_domain}",
      "static.${app_domain}",
      "tariff.${app_domain}",
      "transaction-wrappers.${app_domain}",
      "transactions-explorer.${app_domain}",
      "whitehall-frontend.${app_domain}",
    ]
  }

  #api vdc machines
  govuk::host { 'content-store-1':
    ip             => '10.7.0.11',
    vdc            => 'api',
  }
  govuk::host { 'content-store-2':
    ip             => '10.7.0.12',
    vdc            => 'api',
  }
  govuk::host { 'content-store-3':
    ip             => '10.7.0.13',
    vdc            => 'api',
  }
  govuk::host { 'api-mongo-1':
    ip             => '10.7.0.21',
    vdc            => 'api',
  }
  govuk::host { 'api-mongo-2':
    ip             => '10.7.0.22',
    vdc            => 'api',
  }
  govuk::host { 'api-mongo-3':
    ip             => '10.7.0.23',
    vdc            => 'api',
  }
  #api lb vhosts
  govuk::host { 'api-lb-1':
    ip             => '10.7.0.101',
    vdc            => 'api',
  }
  govuk::host { 'api-lb-2':
    ip             => '10.7.0.102',
    vdc            => 'api',
  }
  govuk::host { 'api-internal-lb':
    ip             => '10.7.1.2',
    vdc            => 'api',
    legacy_aliases => [
      "content-store.${app_domain}",
      "publishing-api.${app_domain}",
    ]
  }

  #backend vdc machines
  govuk::host { 'backend-1':
    ip             => '10.3.0.2',
    vdc            => 'backend',
  }
  govuk::host { 'backend-2':
    ip             => '10.3.0.3',
    vdc            => 'backend',
  }
  govuk::host { 'backend-3':
    ip             => '10.3.0.4',
    vdc            => 'backend',
  }
  govuk::host { 'whitehall-backend-1':
    ip             => '10.3.0.25',
    vdc            => 'backend',
  }
  govuk::host { 'whitehall-backend-2':
    ip             => '10.3.0.26',
    vdc            => 'backend',
  }
  govuk::host { 'whitehall-backend-3':
    ip             => '10.3.0.27',
    vdc            => 'backend',
  }
  govuk::host { 'whitehall-backend-4':
    ip             => '10.3.0.28',
    vdc            => 'backend',
  }
  govuk::host { 'elasticsearch-1':
    ip              => '10.3.0.15',
    vdc             => 'backend',
  }
  govuk::host { 'elasticsearch-2':
    ip              => '10.3.0.16',
    vdc             => 'backend',
  }
  govuk::host { 'elasticsearch-3':
    ip              => '10.3.0.17',
    vdc             => 'backend',
  }
  govuk::host { 'support-1':
    ip              => '10.3.0.5',
    vdc             => 'backend',
    service_aliases => ['support'],
  }
  govuk::host { 'support-contacts-1':
    ip              => '10.3.0.60',
    vdc             => 'backend',
  }
  govuk::host { 'mongo-1':
    ip              => '10.3.0.6',
    vdc             => 'backend',
    legacy_aliases  => ["mongo.backend.${internal_tld}", 'backend-1.mongo'],
    service_aliases => ['mongodb'],
  }
  govuk::host { 'mongo-2':
    ip             => '10.3.0.7',
    vdc            => 'backend',
    legacy_aliases => ['backend-2.mongo'],
  }
  govuk::host { 'mongo-3':
    ip             => '10.3.0.8',
    vdc            => 'backend',
    legacy_aliases => ['backend-3.mongo'],
  }
  govuk::host { 'mapit-server-1':
    ip             => '10.3.0.9',
    vdc            => 'backend',
    legacy_aliases => ['mapit.alpha.gov.uk']
  }
  govuk::host { 'mapit-server-2':
    ip             => '10.3.0.10',
    vdc            => 'backend',
  }
  govuk::host { 'exception-handler-1':
    ip             => '10.3.0.40',
    vdc            => 'backend',
  }
  govuk::host { 'rabbitmq-1':
    ip             => '10.3.0.70',
    vdc            => 'backend',
  }
  govuk::host { 'rabbitmq-2':
    ip             => '10.3.0.71',
    vdc            => 'backend',
  }
  govuk::host { 'rabbitmq-3':
    ip             => '10.3.0.72',
    vdc            => 'backend',
  }
  govuk::host { 'redis-1':
    ip             => '10.3.0.50',
    vdc            => 'backend',
  }
  govuk::host { 'redis-2':
    ip             => '10.3.0.51',
    vdc            => 'backend',
  }
  govuk::host { 'mysql-master-1':
    ip             => '10.3.10.0',
    vdc            => 'backend',
    legacy_aliases => ['master.mysql', "mysql.backend.${internal_tld}"],
  }
  govuk::host { 'mysql-slave-1':
    ip             => '10.3.10.1',
    vdc            => 'backend',
    legacy_aliases => ['slave.mysql' ],
  }
  govuk::host { 'mysql-slave-2':
    ip             => '10.3.10.3',
    vdc            => 'backend',
  }
  govuk::host { 'mysql-backup-1':
    ip             => '10.3.10.2',
    vdc            => 'backend',
    legacy_aliases => ['backup.mysql'],
  }
  govuk::host { 'postgresql-master-1':
    ip             => '10.3.20.10',
    vdc            => 'backend',
  }
  govuk::host { 'transition-postgresql-master-1':
    ip             => '10.3.20.1',
    vdc            => 'backend',
    legacy_aliases => ['transition-master.postgresql', "transition-postgresql.backend.${internal_tld}"],
  }
  govuk::host { 'whitehall-mysql-master-1':
    ip             => '10.3.10.30',
    vdc            => 'backend',
    legacy_aliases => ['whitehall-master.mysql', "whitehall-mysql.backend.${internal_tld}"],
  }
  govuk::host { 'whitehall-mysql-slave-1':
    ip             => '10.3.10.31',
    vdc            => 'backend',
    legacy_aliases => ['whitehall-slave.mysql'],
  }
  govuk::host { 'whitehall-mysql-slave-2':
    ip             => '10.3.10.32',
    vdc            => 'backend',
  }
  govuk::host { 'whitehall-mysql-backup-1':
    ip             => '10.3.10.34',
    vdc            => 'backend',
    legacy_aliases => ['whitehall-backup.mysql'],
  }
  govuk::host { 'backend-lb-1':
    ip             => '10.3.0.101',
    vdc            => 'backend',
  }
  govuk::host { 'backend-lb-2':
    ip             => '10.3.0.102',
    vdc            => 'backend',
  }

  $backend_aliases_orig = [
      'backend-internal-lb',
      "api-external-link-tracker.${app_domain}",
      "asset-manager.${app_domain}",
      "business-support-api.${app_domain}",
      "canary-backend.${app_domain}",
      "collections-publisher.${app_domain}",
      "contacts-admin.${app_domain}",
      "content-planner.${app_domain}",
      "contentapi.${app_domain}",
      "errbit.${app_domain}",
      "external-link-tracker.${app_domain}",
      "fact-cave.${app_domain}",
      "finder-api.${app_domain}",
      "govuk-delivery.${app_domain}",
      "hmrc-manuals-api.${app_domain}",
      "imminence.${app_domain}",
      "kibana.${app_domain}",
      "mapit.${app_domain}",
      "maslow.${app_domain}",
      "need-api.${app_domain}",
      "needotron.${app_domain}",
      "panopticon.${app_domain}",
      "private-frontend.${app_domain}",
      "publisher.${app_domain}",
      "search.${app_domain}",
      "search-admin.${app_domain}",
      "signon.${app_domain}",
      "specialist-publisher.${app_domain}",
      "support.${app_domain}",
      "support-api.${app_domain}",
      "tariff-admin.${app_domain}",
      "tariff-api.${app_domain}",
      "transition.${app_domain}",
      "transition-postgres.${app_domain}",
      "travel-advice-publisher.${app_domain}",
      "url-arbiter.${app_domain}",
      "whitehall-admin.${app_domain}"
      ]

  validate_bool($releaseapp_host_org)
  if $releaseapp_host_org {
    $backend_aliases = flatten([$backend_aliases_orig, ["release.${app_domain}"]])
  } else {
    $backend_aliases = $backend_aliases_orig
  }


  govuk::host { 'backend-internal-lb':
    ip             => '10.3.1.2',
    vdc            => 'backend',
    legacy_aliases => $backend_aliases,
  }

  govuk::host { 'asset-master-1':
    ip             => '10.3.0.20',
    vdc            => 'backend',
    legacy_aliases => [
      "asset-master-1.${app_domain}",
      'asset-master',
      "asset-master.${app_domain}"
    ],
  }

  govuk::host { 'asset-slave-1':
    ip             => '10.3.0.21',
    vdc            => 'backend',
    legacy_aliases => [
      "asset-slave-1.${app_domain}",
      'asset-slave',
      "asset-slave.${app_domain}"
    ],
  }

  # elms (licence finder) vdc machines
  govuk::host { 'licensify-frontend-1':
    ip             => '10.5.0.2',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-frontend-2':
    ip             => '10.5.0.3',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-backend-1':
    ip             => '10.5.0.4',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-backend-2':
    ip             => '10.5.0.5',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-mongo-1':
    ip             => '10.5.0.6',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-mongo-2':
    ip             => '10.5.0.7',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-mongo-3':
    ip             => '10.5.0.8',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-lb-1':
    ip             => '10.5.0.101',
    vdc            => 'licensify',
  }
  govuk::host { 'licensify-lb-2':
    ip             => '10.5.0.102',
    vdc            => 'licensify',
  }

  #licensify load balancer v-shield edge
  govuk::host { 'licensify-internal-lb':
    ip             => '10.5.1.2',
    vdc            => 'licensify',
    legacy_aliases => ["licensify.${app_domain}", "uploadlicence.${app_domain}", "licensify-admin.${app_domain}", "licensing-web-forms.${app_domain}"],
  }

  #efg vdc machines
  govuk::host { 'efg-mysql-master-1':
    ip             => '10.4.0.10',
    vdc            => 'efg',
    legacy_aliases => ['efg.master.mysql'],
  }

  $efg_domain = hiera('efg_domain',"efg.${app_domain}")
  govuk::host { 'efg-frontend-1':
    ip             => '10.4.0.2',
    vdc            => 'efg',
    legacy_aliases => [$efg_domain],
  }
  govuk::host { 'efg-mysql-slave-1':
    ip             => '10.4.0.11',
    vdc            => 'efg',
    legacy_aliases => ['efg.slave.mysql'],
  }

  # redirector vdc machines
  govuk::host { 'redirector-1':
    ip             => '10.6.0.2',
    vdc            => 'redirector',
  }
  govuk::host { 'redirector-2':
    ip             => '10.6.0.3',
    vdc            => 'redirector',
  }
  govuk::host { 'bouncer-1':
    ip             => '10.6.0.4',
    vdc            => 'redirector',
  }
  govuk::host { 'bouncer-2':
    ip             => '10.6.0.5',
    vdc            => 'redirector',
  }
  govuk::host { 'bouncer-3':
    ip             => '10.6.0.6',
    vdc            => 'redirector',
  }

  govuk::host { 'bouncer-vse-lb':
    ip             => $ip_bouncer,
    vdc            => 'redirector',
    legacy_aliases => ["bouncer.${app_domain}"],
  }

  govuk::host { 'redirector-vse-lb':
    ip             => $ip_redirector,
    vdc            => 'redirector',
    legacy_aliases => ["redirector.${app_domain}"],
  }

  # 3rd-party hosts
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '185.40.10.139',
  }

}
