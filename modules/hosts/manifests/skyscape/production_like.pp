class hosts::skyscape::production_like ($platform = $::govuk_platform) {
  # these are real hosts (1-1 mapping between host and service) anything that
  # ends .cluster is maintained for backwards compatibility with ec2

  $app_domain = extlookup('app_domain')

  class { 'hosts::skyscape::dead_hosts':
    platform => $platform,
  }

  #management vdc machines
  host { "puppet-1.management.${platform}":
    ip           => '10.0.0.2',
    host_aliases => ['puppet-1', 'puppet'],
  }
  host { "jenkins-1.management.${platform}":
    ip => '10.0.0.3',
  }
  host { "monitoring.management.${platform}":
    ip           => '10.0.0.20',
    host_aliases => ['monitoring', 'monitoring.cluster', "nagios.${app_domain}", "ganglia.${app_domain}", "graphite.${app_domain}"],
  }
  host { "logging.management.${platform}":
    ip           => '10.0.0.21',
    host_aliases => ['logging', 'graylog.cluster'],
  }
  host { "jumpbox-1.management.${platform}":
    ip => '10.0.0.100',
  }
  host { "jumpbox-2.management.${platform}":
    ip => '10.0.0.200',
  }
  host { "backup-1.management.${platform}":
    ip => '10.0.0.50',
  }
  host { 'vcd00003.vpn.skyscapecs.net':
    ip => '10.202.5.11',
  }
  host { "exception-handler-1.management.${platform}":
    ip           => '10.0.0.4',
    host_aliases => ['exception-handler-1', 'exception-handler', "errbit.${app_domain}"]
  }

  #router vdc machines
  host { "cache-1.router.${platform}":
    ip => '10.1.0.2',
  }
  host { "cache-2.router.${platform}":
    ip => '10.1.0.3',
  }
  host { "cache-3.router.${platform}":
    ip => '10.1.0.4',
  }
  #router lb vhosts
  host { "cache.router.${platform}":
    ip           => '10.1.1.1',
    host_aliases => ['cache', 'cache.cluster', 'router.cluster', 'www.gov.uk']
  }

  #frontend vdc machines
  host { "frontend-1.frontend.${platform}":
    ip           => '10.2.0.2',
    host_aliases => ['frontend-1']
  }
  host { "frontend-2.frontend.${platform}":
    ip           => '10.2.0.3',
    host_aliases => ['frontend-2']
  }
  host { "frontend-3.frontend.${platform}":
    ip           => '10.2.0.4',
    host_aliases => ['frontend-3']
  }
  host { "whitehall-frontend-1.frontend.${platform}":
    ip           => '10.2.0.5',
    host_aliases => ['whitehall-frontend-1']
  }
  host { "whitehall-frontend-2.frontend.${platform}":
    ip           => '10.2.0.6',
    host_aliases => ['whitehall-frontend-2']
  }


  #frontend lb vhosts
  host { "frontend-lb-2.frontend.${platform}":
    ip           => '10.2.0.102',
    host_aliases => ['frontend-lb-2']
  }
  host { "frontend-lb-1.frontend.${platform}":
    ip           => '10.2.0.101',
    host_aliases => ['frontend-lb-1']
  }
  host { "frontend-internal-lb.frontend.${platform}":
    ip           => '10.2.1.2',
    host_aliases => [
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
  host { "backend-1.backend.${platform}":
    ip           => '10.3.0.2',
    host_aliases => ['backend-1']
  }
  host { "backend-2.backend.${platform}":
    ip           => '10.3.0.3',
    host_aliases => ['backend-2']
  }
  host { "backend-3.backend.${platform}":
    ip           => '10.3.0.4',
    host_aliases => ['backend-3']
  }
  host { "support-1.backend.${platform}":
    ip           => '10.3.0.5',
    host_aliases => ['support-1', 'support.cluster']
  }
  host { "mongo-1.backend.${platform}":
    ip           => '10.3.0.6',
    host_aliases => ['mongo-1', "mongo.backend.${platform}", 'mongodb.cluster', 'backend-1.mongo']
  }
  host { "mongo-2.backend.${platform}":
    ip           => '10.3.0.7',
    host_aliases => ['mongo-2', 'backend-2.mongo']
  }
  host { "mongo-3.backend.${platform}":
    ip           => '10.3.0.8',
    host_aliases => ['mongo-3', 'backend-3.mongo']
  }
  host { "mapit-server-1.backend.${platform}":
    ip           => '10.3.0.9',
    host_aliases => ['mapit-server-1','mapit.alpha.gov.uk']
  }
  host { "mapit-server-2.backend.${platform}":
    ip           => '10.3.0.10',
    host_aliases => ['mapit-server-2']
  }
  host { "mysql-master-1.backend.${platform}":
    ip           => '10.3.10.0',
    host_aliases => ['mysql-master-1', 'master.mysql', "mysql.backend.${platform}"]
  }
  host { "mysql-slave-1.backend.${platform}":
    ip           => '10.3.10.1',
    host_aliases => ['mysql-slave-1', 'slave.mysql']
  }
  host { "backend-lb-1.backend.${platform}":
    ip           => '10.3.0.101',
    host_aliases => ['backend-lb-1']
  }
  host { "backend-lb-2.backend.${platform}":
    ip           => '10.3.0.102',
    host_aliases => ['backend-lb-2']
  }
  host { "backend-internal-lb.backend.${platform}":
    ip           => '10.3.1.2',
    host_aliases => [
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
    ]
  }
  host { "asset-master.backend.${platform}":
    ip           => '10.3.0.20',
    host_aliases => ['asset-master', "asset-master.${app_domain}"]
  }
  host { "asset-slave.backend.${platform}":
    ip           => '10.3.0.21',
    host_aliases => ['asset-slave', "asset-slave.${app_domain}"]
  }
  host { "datainsight-1.backend.${platform}":
    ip           => '10.3.0.30',
    host_aliases => [
      'datainsight-1',
      "datainsight.${app_domain}",
      "datainsight-narrative-recorder.${app_domain}",
      "datainsight-weekly-reach-recorder.${app_domain}",
      "datainsight-todays-activity-recorder.${app_domain}",
      "datainsight-everything-recorder.${app_domain}",
      "datainsight-format-success-recorder.${app_domain}"
    ]
  }
  host { "akamai-logs-1.backend.${platform}":
    ip           => '10.3.0.11',
    host_aliases => ['akamai-logs-1']
  }
  host { "akamai-logs-backup-1.backend.${platform}":
    ip           => '10.3.0.12',
    host_aliases => ['akamai-logs-backup-1']
  }

  # elms (licence finder) vdc machines
  host { "licensify-frontend-1.licensify.${platform}":
    ip           => '10.5.0.2',
    host_aliases => ['licensify-frontend-1']
  }
  host { "licensify-frontend-2.licensify.${platform}":
    ip           => '10.5.0.3',
    host_aliases => ['licensify-frontend-2']
  }
  host { "licensify-backend-1.licensify.${platform}":
    ip           => '10.5.0.4',
    host_aliases => ['licensify-backend-1']
  }
  host { "licensify-backend-2.licensify.${platform}":
    ip           => '10.5.0.5',
    host_aliases => ['licensify-backend-2']
  }
  host { "licensify-mongo-1.licensify.${platform}":
    ip           => '10.5.0.6',
    host_aliases => ['licensify-mongo-1']
  }
  host { "licensify-mongo-2.licensify.${platform}":
    ip           => '10.5.0.7',
    host_aliases => ['licensify-mongo-2']
  }
  host { "licensify-mongo-3.licensify.${platform}":
    ip           => '10.5.0.8',
    host_aliases => ['licensify-mongo-3']
  }
  host { "licensify-lb-1.licensify.${platform}":
    ip           => '10.5.0.101',
    host_aliases => ['licensify-lb-1']
  }
  host { "licensify-lb-2.licensify.${platform}":
    ip           => '10.5.0.102',
    host_aliases => ['licensify-lb-2']
  }

  #licensify load balancer v-shield edge
  host { 'licensify-internal-lb.licensify':
    ip           => '10.5.1.2',
    host_aliases => ["licensify.${app_domain}", "uploadlicensify.${app_domain}", "licensify-admin.${app_domain}"]
  }

  #efg vdc machines
  host { "efg-mysql-master-1.efg.${platform}":
    ip           => '10.4.0.10',
    host_aliases => ['efg-mysql-master-1', 'efg.master.mysql']
  }
  host { "efg-frontend-1.efg.${platform}":
    ip           => '10.4.0.2',
    host_aliases => ['efg-frontend-1']
  }
  host { "efg-mysql-slave-1.efg.${platform}":
    ip           => '10.4.0.11',
    host_aliases => ['efg-mysql-slave-1', 'efg.slave.mysql']
  }

  # redirector vdc machines
  host { "redirector-1.redirector.${platform}":
    ip           => '10.6.0.2',
    host_aliases => ['redirector-1']
  }
  host { "redirector-2.redirector.${platform}":
    ip           => '10.6.0.3',
    host_aliases => ['redirector-2']
  }

  # apto vdc
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '217.171.99.28',
  }

}
