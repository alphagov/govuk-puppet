class hosts::skyscape::production_like ($platform = $::govuk_platform) {
  # these are real hosts (1-1 mapping between host and service) anything that
  # ends .cluster is maintained for backwards compatibility with ec2

  $app_domain = extlookup('app_domain')

  #management vdc machines
  govuk::host { 'puppet-1':
    ip             => '10.0.0.2',
    vdc            => 'management',
    legacy_aliases => ['puppet-1', 'puppet'],
  }
  govuk::host { 'jenkins-1':
    ip             => '10.0.0.3',
    vdc            => 'management',
    legacy_aliases => ['jenkins-1'],
  }
  govuk::host { 'monitoring':
    ip              => '10.0.0.20',
    vdc             => 'management',
    legacy_aliases  => ['monitoring', "nagios.${app_domain}", "ganglia.${app_domain}", "graphite.${app_domain}"],
    service_aliases => ['monitoring'],
  }
  govuk::host { 'logging':
    ip              => '10.0.0.21',
    vdc             => 'management',
    legacy_aliases  => ['logging'],
    service_aliases => ['graylog'],
  }
  govuk::host { 'jumpbox-1':
    ip              => '10.0.0.100',
    vdc             => 'management',
    legacy_aliases  => ['jumpbox-1'],
  }
  govuk::host { 'jumpbox-2':
    ip              => '10.0.0.200',
    vdc             => 'management',
    legacy_aliases  => ['jumpbox-2'],
  }
  govuk::host { 'backup-1':
    ip              => '10.0.0.50',
    vdc             => 'management',
    legacy_aliases  => ['backup-1'],
  }
  govuk::host { 'exception-handler-1':
    ip             => '10.0.0.4',
    vdc            => 'management',
    legacy_aliases => ['exception-handler-1', 'exception-handler', "errbit.${app_domain}"]
  }

  #router vdc machines
  govuk::host { 'cache-1':
    ip              => '10.1.0.2',
    vdc             => 'router',
    legacy_aliases  => ['cache-1'],
  }
  govuk::host { 'cache-2':
    ip              => '10.1.0.3',
    vdc             => 'router',
    legacy_aliases  => ['cache-2'],
  }
  govuk::host { 'cache-3':
    ip              => '10.1.0.4',
    vdc             => 'router',
    legacy_aliases  => ['cache-3'],
  }

  #router lb vhosts
  govuk::host { 'cache':
    ip              => '10.1.1.1',
    vdc             => 'router',
    legacy_aliases  => ['cache', 'www.gov.uk'],
    service_aliases => ['cache', 'router'],
  }

  #frontend vdc machines
  govuk::host { 'frontend-1':
    ip             => '10.2.0.2',
    vdc            => 'frontend',
    legacy_aliases => ['frontend-1']
  }
  govuk::host { 'frontend-2':
    ip             => '10.2.0.3',
    vdc            => 'frontend',
    legacy_aliases => ['frontend-2']
  }
  govuk::host { 'frontend-3':
    ip             => '10.2.0.4',
    vdc            => 'frontend',
    legacy_aliases => ['frontend-3']
  }
  govuk::host { 'whitehall-frontend-1':
    ip             => '10.2.0.5',
    vdc            => 'frontend',
    legacy_aliases => ['whitehall-frontend-1']
  }
  govuk::host { 'whitehall-frontend-2':
    ip             => '10.2.0.6',
    vdc            => 'frontend',
    legacy_aliases => ['whitehall-frontend-2']
  }


  #frontend lb vhosts
  govuk::host { 'frontend-lb-1':
    ip             => '10.2.0.101',
    vdc            => 'frontend',
    legacy_aliases => ['frontend-lb-1'],
  }
  govuk::host { 'frontend-lb-2':
    ip             => '10.2.0.102',
    vdc            => 'frontend',
    legacy_aliases => ['frontend-lb-2'],
  }
  govuk::host { 'frontend-internal-lb':
    ip             => '10.2.1.2',
    vdc            => 'frontend',
    legacy_aliases => [
      'frontend-internal-lb',
      "businesssupportfinder.${app_domain}",
      "calendars.${app_domain}",
      "canary-frontend.${app_domain}",
      "datainsight-frontend.${app_domain}",
      "designprinciples.${app_domain}",
      "efg.${app_domain}",
      "feedback.${app_domain}",
      "frontend.${app_domain}",
      "licencefinder.${app_domain}",
      "publicapi.${app_domain}",
      "smartanswers.${app_domain}",
      "static.${app_domain}",
      "tariff.${app_domain}",
      "travel-advice-frontend.${app_domain}",
      "whitehall-frontend.${app_domain}",
      "www.${app_domain}"
    ]
  }

  #backend vdc machines
  govuk::host { 'backend-1':
    ip             => '10.3.0.2',
    vdc            => 'backend',
    legacy_aliases => ['backend-1'],
  }
  govuk::host { 'backend-2':
    ip             => '10.3.0.3',
    vdc            => 'backend',
    legacy_aliases => ['backend-2'],
  }
  govuk::host { 'backend-3':
    ip             => '10.3.0.4',
    vdc            => 'backend',
    legacy_aliases => ['backend-3'],
  }
  govuk::host { 'support-1':
    ip              => '10.3.0.5',
    vdc             => 'backend',
    legacy_aliases  => ['support-1'],
    service_aliases => ['support'],
  }
  govuk::host { 'mongo-1':
    ip              => '10.3.0.6',
    vdc             => 'backend',
    legacy_aliases  => ['mongo-1', "mongo.backend.${platform}", 'backend-1.mongo'],
    service_aliases => ['mongodb'],
  }
  govuk::host { 'mongo-2':
    ip             => '10.3.0.7',
    vdc            => 'backend',
    legacy_aliases => ['mongo-2', 'backend-2.mongo'],
  }
  govuk::host { 'mongo-3':
    ip             => '10.3.0.8',
    vdc            => 'backend',
    legacy_aliases => ['mongo-3', 'backend-3.mongo'],
  }
  govuk::host { 'mapit-server-1':
    ip             => '10.3.0.9',
    vdc            => 'backend',
    legacy_aliases => ['mapit-server-1', 'mapit.alpha.gov.uk']
  }
  govuk::host { 'mapit-server-2':
    ip             => '10.3.0.10',
    vdc            => 'backend',
    legacy_aliases => ['mapit-server-2'],
  }
  govuk::host { 'redis-1':
    ip             => '10.3.0.50',
    vdc            => 'backend',
    legacy_aliases => ['redis-1'],
  }
  govuk::host { 'mysql-master-1':
    ip             => '10.3.10.0',
    vdc            => 'backend',
    legacy_aliases => ['mysql-master-1', 'master.mysql', "mysql.backend.${platform}"],
  }
  govuk::host { 'mysql-slave-1':
    ip             => '10.3.10.1',
    vdc            => 'backend',
    legacy_aliases => ['mysql-slave-1', 'slave.mysql'],
  }
  govuk::host { 'backend-lb-1':
    ip             => '10.3.0.101',
    vdc            => 'backend',
    legacy_aliases => ['backend-lb-1']
  }
  govuk::host { 'backend-lb-2':
    ip             => '10.3.0.102',
    vdc            => 'backend',
    legacy_aliases => ['backend-lb-2']
  }
  govuk::host { 'backend-internal-lb':
    ip             => '10.3.1.2',
    vdc            => 'backend',
    legacy_aliases => [
      'backend-internal-lb',
      "canary-backend.${app_domain}",
      "contentapi.${app_domain}",
      "imminence.${app_domain}",
      "mapit.${app_domain}",
      "migratorator.${app_domain}",
      "needotron.${app_domain}",
      "panopticon.${app_domain}",
      "private-frontend.${app_domain}",
      "publisher.${app_domain}",
      "search.${app_domain}",
      "signon.${app_domain}",
      "support.${app_domain}",
      "tariff-api.${app_domain}",
      "travel-advice-publisher.${app_domain}",
      "whitehall-admin.${app_domain}"
    ],
  }
  govuk::host { 'asset-master':
    ip             => '10.3.0.20',
    vdc            => 'backend',
    legacy_aliases => ['asset-master', "asset-master.${app_domain}"],
  }
  govuk::host { 'asset-slave':
    ip             => '10.3.0.21',
    vdc            => 'backend',
    legacy_aliases => ['asset-slave', "asset-slave.${app_domain}"],
  }
  govuk::host { 'datainsight-1':
    ip             => '10.3.0.30',
    vdc            => 'backend',
    legacy_aliases => [
      'datainsight-1',
      "datainsight.${app_domain}",
      "datainsight-narrative-recorder.${app_domain}",
      "datainsight-weekly-reach-recorder.${app_domain}",
      "datainsight-todays-activity-recorder.${app_domain}",
      "datainsight-everything-recorder.${app_domain}",
      "datainsight-format-success-recorder.${app_domain}",
      "datainsight-insidegov-recorder.${app_domain}"
    ],
  }
  govuk::host { 'akamai-logs-1':
    ip             => '10.3.0.11',
    vdc            => 'backend',
    legacy_aliases => ['akamai-logs-1'],
  }
  govuk::host { 'akamai-logs-backup-1':
    ip             => '10.3.0.12',
    vdc            => 'backend',
    legacy_aliases => ['akamai-logs-backup-1'],
  }

  # elms (licence finder) vdc machines
  govuk::host { 'licensify-frontend-1':
    ip             => '10.5.0.2',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-frontend-1'],
  }
  govuk::host { 'licensify-frontend-2':
    ip             => '10.5.0.3',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-frontend-2'],
  }
  govuk::host { 'licensify-backend-1':
    ip             => '10.5.0.4',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-backend-1'],
  }
  govuk::host { 'licensify-backend-2':
    ip             => '10.5.0.5',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-backend-2'],
  }
  govuk::host { 'licensify-mongo-1':
    ip             => '10.5.0.6',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-mongo-1'],
  }
  govuk::host { 'licensify-mongo-2':
    ip             => '10.5.0.7',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-mongo-2'],
  }
  govuk::host { 'licensify-mongo-3':
    ip             => '10.5.0.8',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-mongo-3'],
  }
  govuk::host { 'licensify-lb-1':
    ip             => '10.5.0.101',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-lb-1'],
  }
  govuk::host { 'licensify-lb-2':
    ip             => '10.5.0.102',
    vdc            => 'licensify',
    legacy_aliases => ['licensify-lb-2'],
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
    legacy_aliases => ['efg-mysql-master-1', 'efg.master.mysql'],
  }
  govuk::host { 'efg-frontend-1':
    ip             => '10.4.0.2',
    vdc            => 'efg',
    legacy_aliases => ['efg-frontend-1'],
  }
  govuk::host { 'efg-mysql-slave-1':
    ip             => '10.4.0.11',
    vdc            => 'efg',
    legacy_aliases => ['efg-mysql-slave-1', 'efg.slave.mysql'],
  }

  # redirector vdc machines
  govuk::host { 'redirector-1':
    ip             => '10.6.0.2',
    vdc            => 'redirector',
    legacy_aliases => ['redirector-1'],
  }
  govuk::host { 'redirector-2':
    ip             => '10.6.0.3',
    vdc            => 'redirector',
    legacy_aliases => ['redirector-2'],
  }

  # 3rd-party hosts
  host { 'vcd00003.vpn.skyscapecs.net':
    ip => '10.202.5.11',
  }
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '217.171.99.28',
  }

}
