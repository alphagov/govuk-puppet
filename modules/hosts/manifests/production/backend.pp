# == Class: hosts::production::backend
#
# Manage /etc/hosts entries specific to machines in the backend vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*releaseapp_host_org*]
#   Whether to create the `release.$app_domain` vhost alias within this environment.
#   Default: false
#
class hosts::production::backend (
  $app_domain,
  $releaseapp_host_org = false,
) {

  $internal_tld = hiera('internal_tld', 'production')

  Govuk::Host {
    vdc => 'backend',
  }

  govuk::host { 'backend-1':
    ip  => '10.3.0.2',
  }
  govuk::host { 'backend-2':
    ip  => '10.3.0.3',
  }
  govuk::host { 'backend-3':
    ip  => '10.3.0.4',
  }
  govuk::host { 'whitehall-backend-1':
    ip  => '10.3.0.25',
  }
  govuk::host { 'whitehall-backend-2':
    ip  => '10.3.0.26',
  }
  govuk::host { 'whitehall-backend-3':
    ip  => '10.3.0.27',
  }
  govuk::host { 'whitehall-backend-4':
    ip  => '10.3.0.28',
  }
  govuk::host { 'elasticsearch-1':
    ip  => '10.3.0.15',
  }
  govuk::host { 'elasticsearch-2':
    ip  => '10.3.0.16',
  }
  govuk::host { 'elasticsearch-3':
    ip  => '10.3.0.17',
  }
  govuk::host { 'support-1':
    ip              => '10.3.0.5',
    service_aliases => ['support'],
  }
  govuk::host { 'support-contacts-1':
    ip  => '10.3.0.60',
  }
  govuk::host { 'mongo-1':
    ip              => '10.3.0.6',
    # FIXME this legacy alias is now not used anywhere in Puppet
    # However, before it is removed, We'll need to reconfigure
    # the mongo cluster to use the mongo-n.backend
    legacy_aliases  => ["mongo.backend.${internal_tld}", 'backend-1.mongo'],
    service_aliases => ['mongodb'],
  }
  govuk::host { 'mongo-2':
    ip             => '10.3.0.7',
    # FIXME this legacy alias is now not used anywhere in Puppet
    # However, before it is removed, We'll need to reconfigure
    # the mongo cluster to use the mongo-n.backend
    legacy_aliases => ['backend-2.mongo'],
  }
  govuk::host { 'mongo-3':
    ip             => '10.3.0.8',
    # FIXME this legacy alias is now not used anywhere in Puppet
    # However, before it is removed, We'll need to reconfigure
    # the mongo cluster to use the mongo-n.backend
    legacy_aliases => ['backend-3.mongo'],
  }
  govuk::host { 'mapit-server-1':
    ip             => '10.3.0.9',
    legacy_aliases => ['mapit.alpha.gov.uk']
  }
  govuk::host { 'mapit-server-2':
    ip  => '10.3.0.10',
  }
  govuk::host { 'exception-handler-1':
    ip  => '10.3.0.40',
  }
  govuk::host { 'rabbitmq-1':
    ip  => '10.3.0.70',
  }
  govuk::host { 'rabbitmq-2':
    ip  => '10.3.0.71',
  }
  govuk::host { 'rabbitmq-3':
    ip  => '10.3.0.72',
  }
  govuk::host { 'redis-1':
    ip  => '10.3.0.50',
  }
  govuk::host { 'redis-2':
    ip  => '10.3.0.51',
  }
  govuk::host { 'mysql-master-1':
    ip             => '10.3.10.0',
    legacy_aliases => ['master.mysql', "mysql.backend.${internal_tld}"],
  }
  govuk::host { 'mysql-slave-1':
    ip             => '10.3.10.1',
    legacy_aliases => ['slave.mysql' ],
  }
  govuk::host { 'mysql-slave-2':
    ip  => '10.3.10.3',
  }
  govuk::host { 'mysql-backup-1':
    ip             => '10.3.10.2',
    legacy_aliases => ['backup.mysql'],
  }
  govuk::host { 'postgresql-master-1':
    ip  => '10.3.20.10',
  }
  govuk::host { 'postgresql-slave-1':
    ip  => '10.3.20.11',
  }
  govuk::host { 'transition-postgresql-master-1':
    ip             => '10.3.20.1',
    legacy_aliases => ['transition-master.postgresql', "transition-postgresql.backend.${internal_tld}"],
  }
  govuk::host { 'transition-postgresql-slave-1':
    ip             => '10.3.20.2',
    legacy_aliases => ['transition-slave.postgresql'],
  }
  govuk::host { 'whitehall-mysql-master-1':
    ip             => '10.3.10.30',
    legacy_aliases => ['whitehall-master.mysql', "whitehall-mysql.backend.${internal_tld}"],
  }
  govuk::host { 'whitehall-mysql-slave-1':
    ip             => '10.3.10.31',
    legacy_aliases => ['whitehall-slave.mysql'],
  }
  govuk::host { 'whitehall-mysql-slave-2':
    ip  => '10.3.10.32',
  }
  govuk::host { 'whitehall-mysql-backup-1':
    ip             => '10.3.10.34',
    legacy_aliases => ['whitehall-backup.mysql'],
  }
  govuk::host { 'backend-lb-1':
    ip  => '10.3.0.101',
  }
  govuk::host { 'backend-lb-2':
    ip  => '10.3.0.102',
  }

  $backend_aliases_orig = [
      'backend-internal-lb',
      "api-external-link-tracker.${app_domain}",
      "asset-manager.${app_domain}",
      "business-support-api.${app_domain}",
      "canary-backend.${app_domain}",
      "collections-api.${app_domain}",
      "collections-publisher.${app_domain}",
      "contacts-admin.${app_domain}",
      "content-planner.${app_domain}",
      "content-register.${app_domain}",
      "contentapi.${app_domain}",
      "email-alert-api.${app_domain}",
      "errbit.${app_domain}",
      "external-link-tracker.${app_domain}",
      "finder-api.${app_domain}",
      "govuk-delivery.${app_domain}",
      "hmrc-manuals-api.${app_domain}",
      "imminence.${app_domain}",
      "kibana.${app_domain}",
      "mapit.${app_domain}",
      "maslow.${app_domain}",
      "need-api.${app_domain}",
      "panopticon.${app_domain}",
      "private-frontend.${app_domain}",
      "publisher.${app_domain}",
      # TODO: change this over to publishing-api once the application
      # correct forwards requests across.
      "publishing-api-test.${app_domain}",
      "search.${app_domain}",
      "search-admin.${app_domain}",
      "short-url-manager.${app_domain}",
      "signon.${app_domain}",
      "specialist-publisher.${app_domain}",
      "support.${app_domain}",
      "support-api.${app_domain}",
      "tariff-admin.${app_domain}",
      "tariff-api.${app_domain}",
      "transition.${app_domain}",
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
    legacy_aliases => $backend_aliases,
  }

  govuk::host { 'asset-master-1':
    ip             => '10.3.0.20',
    legacy_aliases => [
      "asset-master-1.${app_domain}",
      'asset-master',
      "asset-master.${app_domain}"
    ],
  }

  govuk::host { 'asset-slave-1':
    ip             => '10.3.0.21',
    legacy_aliases => [
      "asset-slave-1.${app_domain}",
      'asset-slave',
      "asset-slave.${app_domain}"
    ],
  }
}
