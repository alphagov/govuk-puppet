# == Class: hosts::production
#
# Manage /etc/hosts entries for various machines
#
# these are real hosts (1-1 mapping between host and service) anything that
# ends .cluster is maintained for backwards compatibility with ec2
#
# === Parameters:
#
# [*suffixed_hosts*]
#   Create all hosts entries with numeric suffixes. Fixes some legacy
#   machines that were named incorrectly, e.g. `asset-master` vs
#   `asset-master-1`.
#   Default: false
#
# [*apt_mirror_internal*]
#   Point `apt.production.alphagov.co.uk` to `apt-1` within this
#   environment. Instead of going to the Production VSE.
#   Default: false
#
class hosts::production (
  $suffixed_hosts         = false,
  $whitehall_shares_mysql = true,
  $apt_mirror_internal    = false,
) {

  validate_bool($suffixed_hosts)
  if $suffixed_hosts {
    $ensure_with_suffix = present
    $ensure_without_suffix = absent
  } else {
    $ensure_with_suffix = absent
    $ensure_without_suffix = present
  }

  $app_domain = hiera('app_domain')
  $internal_tld = extlookup('internal_tld', 'production')

  validate_bool($apt_mirror_internal)
  $apt_aliases = $apt_mirror_internal ? {
    true    => ['apt.production.alphagov.co.uk'],
    default => undef,
  }

  # FIXME: Can be removed after platform1 migration
  # - To match interim-platform behaviour, this should be 'true'
  # - To match platform-one behaviour, this should be 'false'
  #
  # When removing this, remember to flatten the 'false' parameters below into their
  # respective hosts aliases, to reverse the default in the class parameters and to
  # remove the hieradata from the deployment repo.
  #
  if $whitehall_shares_mysql {
    # whitehall-mysql.master and whitehall-mysql.slave point to shared mysql servers
    $mysql_master_1_legacy_aliases           = ['master.mysql', "mysql.backend.${internal_tld}", 'whitehall-master.mysql' ]
    $mysql_slave_1_legacy_aliases            = ['slave.mysql', 'whitehall-slave.mysql' ]
    $whitehall_mysql_master_1_legacy_aliases = ["whitehall-mysql.backend.${internal_tld}"]
    $whitehall_mysql_slave_1_legacy_aliases  = undef
  } else {
    $mysql_master_1_legacy_aliases           = ['master.mysql', "mysql.backend.${internal_tld}"]
    $mysql_slave_1_legacy_aliases            = ['slave.mysql' ]
    # whitehall-mysql.master and whitehall-mysql.slave point to their respective servers
    $whitehall_mysql_master_1_legacy_aliases = ['whitehall-master.mysql', "whitehall-mysql.backend.${internal_tld}"]
    $whitehall_mysql_slave_1_legacy_aliases  = ['whitehall-slave.mysql']
  }

  # Remove old exception-handler host entry.
  # It's now in the backend vDC.  Without this, the exception-handler-1 alias was
  # present in both host entries
  # This can be removed when it's run everywhere
  host { "exception-handler-1.management.${internal_tld}":
    ensure       => absent,
  }

  #management vdc machines
  # FIXME: Remove once absent from all machines
  govuk::host { 'puppet-1':
    ensure          => 'absent',
    ip              => '10.0.0.2',
    vdc             => 'management',
  }
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

  govuk::host { 'monitoring':
    ensure          => $ensure_without_suffix,
    ip              => '10.0.0.20',
    vdc             => 'management',
    legacy_aliases  => ["nagios.${app_domain}"],
    service_aliases => ['monitoring', 'alert'],
  }
  govuk::host { 'monitoring-1':
    ensure          => $ensure_with_suffix,
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
  $website_host = hiera('website_host', 'www.gov.uk')
  govuk::host { 'cache':
    ip              => '10.1.1.1',
    vdc             => 'router',
    legacy_aliases  => [
      'cache',
      $website_host,
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
      "contacts-frontend.${app_domain}",
      "designprinciples.${app_domain}",
      "feedback.${app_domain}",
      "finder-frontend.${app_domain}",
      "frontend.${app_domain}",
      "licencefinder.${app_domain}",
      "limelight.${app_domain}",
      "publicapi.${app_domain}",
      "public-link-tracker.${app_domain}",
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

  # FIXME: Remove when deployed to Platform1.
  govuk::host { 'whitehall-frontend-lb-1':
    ensure         => absent,
    ip             => '10.2.0.111',
    vdc            => 'frontend',
  }
  govuk::host { 'whitehall-frontend-lb-2':
    ensure         => absent,
    ip             => '10.2.0.112',
    vdc            => 'frontend',
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
    # FIXME: See comments at top of file regarding post-migration removal
    legacy_aliases => $mysql_master_1_legacy_aliases,
  }
  govuk::host { 'mysql-slave-1':
    ip             => '10.3.10.1',
    vdc            => 'backend',
    # FIXME: See comments at top of file regarding post-migration removal
    legacy_aliases => $mysql_slave_1_legacy_aliases,
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
  govuk::host { 'whitehall-mysql-master-1':
    ip             => '10.3.10.30',
    vdc            => 'backend',
    # FIXME: See comments at top of file regarding post-migration removal
    legacy_aliases => $whitehall_mysql_master_1_legacy_aliases,
  }
  govuk::host { 'whitehall-mysql-slave-1':
    ip             => '10.3.10.31',
    vdc            => 'backend',
    # FIXME: See comments at top of file regarding post-migration removal
    legacy_aliases => $whitehall_mysql_slave_1_legacy_aliases,
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
      "contacts-admin.${app_domain}",
      "content-planner.${app_domain}",
      "contentapi.${app_domain}",
      "errbit.${app_domain}",
      "external-link-tracker.${app_domain}",
      "fact-cave.${app_domain}",
      "finder-api.${app_domain}",
      "govuk-delivery.${app_domain}",
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
      "signon.${app_domain}",
      "specialist-publisher.${app_domain}",
      "support.${app_domain}",
      "tariff-admin.${app_domain}",
      "tariff-api.${app_domain}",
      "transition.${app_domain}",
      "travel-advice-publisher.${app_domain}",
      "whitehall-admin.${app_domain}"
      ]

  if str2bool(extlookup('releaseapp_host_org', 'no')) {
    $backend_aliases = flatten([$backend_aliases_orig, ["release.${app_domain}"]])
  } else {
    $backend_aliases = $backend_aliases_orig
  }


  govuk::host { 'backend-internal-lb':
    ip             => '10.3.1.2',
    vdc            => 'backend',
    legacy_aliases => $backend_aliases,
  }

  govuk::host { 'asset-master':
    ensure         => $ensure_without_suffix,
    ip             => '10.3.0.20',
    vdc            => 'backend',
    legacy_aliases => ["asset-master.${app_domain}"],
  }
  govuk::host { 'asset-master-1':
    ensure         => $ensure_with_suffix,
    ip             => '10.3.0.20',
    vdc            => 'backend',
    legacy_aliases => [
      "asset-master-1.${app_domain}",
      'asset-master',
      "asset-master.${app_domain}"
    ],
  }

  govuk::host { 'asset-slave':
    ensure         => $ensure_without_suffix,
    ip             => '10.3.0.21',
    vdc            => 'backend',
    legacy_aliases => ["asset-slave.${app_domain}"],
  }
  govuk::host { 'asset-slave-1':
    ensure         => $ensure_with_suffix,
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
    legacy_aliases => ["licensify.${app_domain}", "uploadlicence.${app_domain}", "licensify-admin.${app_domain}"],
  }

  #efg vdc machines
  govuk::host { 'efg-mysql-master-1':
    ip             => '10.4.0.10',
    vdc            => 'efg',
    legacy_aliases => ['efg.master.mysql'],
  }

  $efg_domain = extlookup('efg_domain',"efg.${app_domain}")
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
    ip             => extlookup('ip_bouncer','127.0.0.1'),
    vdc            => 'redirector',
    legacy_aliases => ["bouncer.${app_domain}"],
  }

  govuk::host { 'redirector-vse-lb':
    ip             => extlookup('ip_redirector','127.0.0.1'),
    vdc            => 'redirector',
    legacy_aliases => ["redirector.${app_domain}"],
  }

  # 3rd-party hosts
  host { 'vcd00003.vpn.skyscapecs.net':
    ip => '10.202.5.11',
  }
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '217.171.99.28',
  }

}
