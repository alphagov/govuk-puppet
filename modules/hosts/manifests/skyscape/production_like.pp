class hosts::skyscape::production_like ($platform = $::govuk_platform) {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2

  #Management VDC machines
  host { "puppet-1.management.${platform}"    : ip  => "10.0.0.2", host_aliases  => [ "puppet-1", "puppet" ] }
  host { "jenkins-1.management.${platform}"   : ip  => "10.0.0.3" }
  host { "monitoring.management.${platform}"  : ip  => "10.0.0.20", host_aliases => ["monitoring","monitoring.cluster"] }
  host { "logging.management.${platform}"     : ip  => "10.0.0.21", host_aliases => ["logging","graylog.cluster"]}
  host { "jumpbox-1.management.${platform}"   : ip  => "10.0.0.100" }
  host { "jumpbox-2.management.${platform}"   : ip  => "10.0.0.200" }
  host { "vcd00003.vpn.skyscapecs.net"        : ip  => "10.202.5.11" }

  #Router VDC machines
  host { "cache-1.router.${platform}"         : ip => "10.1.0.2" }
  host { "cache-2.router.${platform}"         : ip => "10.1.0.3" }
  host { "cache-3.router.${platform}"         : ip => "10.1.0.4" }
  host { "router-mongo-1.router.${platform}"  : ip => "10.1.0.5", host_aliases => ['router-mongo-1', 'router-1.mongo'] }
  host { "router-mongo-2.router.${platform}"  : ip => "10.1.0.6", host_aliases => ['router-mongo-2', 'router-2.mongo'] }
  host { "router-mongo-3.router.${platform}"  : ip => "10.1.0.7", host_aliases => ['router-mongo-3', 'router-3.mongo'] }

  #Router LB vhosts
  host { "cache.router.${platform}"           : ip => "10.1.1.1", host_aliases => ["cache",
                                                                                  "cache.cluster",
                                                                                  "router.cluster",
                                                                                  "www.gov.uk"
                                                                                  ]}

  #Frontend VDC machines
  host { "frontend-1.frontend.${platform}"    : ip => "10.2.0.2", host_aliases => ["frontend-1",
                                                                                  "tariff.${platform}.alphagov.co.uk",
                                                                                  "planner.${platform}.alphagov.co.uk",
                                                                                  "licencefinder.${platform}.alphagov.co.uk",
                                                                                  "designprinciples.${platform}.alphagov.co.uk",
                                                                                  "feedback.${platform}.alphagov.co.uk",
                                                                                  ]}
  host { "frontend-2.frontend.${platform}"              : ip => "10.2.0.3" }
  host { "frontend-3.frontend.${platform}"              : ip => "10.2.0.4" }
  host { "whitehall-frontend-1.frontend.${platform}"    : ip => "10.2.0.5", host_aliases => ["whitehall-frontend-1",
                                                                                            "whitehall-frontend.${platform}.alphagov.co.uk",
                                                                                            "whitehall-search.${platform}.alphagov.co.uk"
                                                                                            ]}
  host { "whitehall-frontend-2.frontend.${platform}"    : ip => "10.2.0.6", host_aliases => ["whitehall-frontend-2"]}


  #Frontend LB vhosts
  host { "calendars.frontend.${platform}"               : ip => "10.2.1.1", host_aliases => ["calendars",
                                                                                            "calendars.${platform}.alphagov.co.uk"
                                                                                            ]}
  host { "static.frontend.${platform}"                  : ip => "10.2.1.2", host_aliases => ["static",
                                                                                            "static.${platform}.alphagov.co.uk"
                                                                                            ]}
  host { "search.frontend.${platform}"                  : ip => "10.2.1.3", host_aliases => ["search",
                                                                                            "search.${platform}.alphagov.co.uk"
                                                                                            ]}
  host { "frontend.frontend.${platform}"                : ip => "10.2.1.4", host_aliases => ["frontend",
                                                                                            "frontend.${platform}.alphagov.co.uk"
                                                                                            ]}
  host { "smartanswers.frontend.${platform}"            : ip => "10.2.1.5", host_aliases => ["smartanswers",
                                                                                            "smartanswers.${platform}.alphagov.co.uk"
                                                                                            ]}

  #Backend VDC machines
  host { "backend-1.backend.${platform}"         : ip => "10.3.0.2", host_aliases =>  ["backend-1",
                                                                                      "panopticon.${platform}.alphagov.co.uk",
                                                                                      "publisher.${platform}.alphagov.co.uk",
                                                                                      "tariff-api.${platform}.alphagov.co.uk",
                                                                                      "contentapi.${platform}.alphagov.co.uk"
                                                                                      ]}
  host { "backend-2.backend.${platform}"         : ip => "10.3.0.3", host_aliases => ['backend-2'] }
  host { "backend-3.backend.${platform}"         : ip => "10.3.0.4", host_aliases => ['backend-3'] }
  host { "support-1.backend.${platform}"         : ip => "10.3.0.5", host_aliases =>  ["support-1",
                                                                                      "support.cluster"
                                                                                      ]}
  host { "mongo-1.backend.${platform}"           : ip => "10.3.0.6", host_aliases =>  ["mongo-1", "mongo.backend.${platform}",
                                                                                      "mongodb.cluster", "backend-1.mongo"
                                                                                      ]}
<<<<<<< HEAD
  host { "mongo-2.backend.${platform}"           : ip => "10.3.0.7", host_aliases => ['mongo-2', 'backend-2.mongo'] }
  host { "mongo-3.backend.${platform}"           : ip => "10.3.0.8", host_aliases => ['mongo-3', 'backend-3.mongo'] }

  host { "mapit-server-1.backend.${platform}"    : ip => "10.3.0.9", host_aliases => [
    "mapit-server-1",
    "mapit.alpha.gov.uk",
    "mapit.production.alphagov.co.uk",
    "mapit" ]}
  host { "mapit-server-2.backend.${platform}"    : ip => "10.3.0.10", host_aliases => ["mapit-server-2"]}
  host { "mysql-master-1.backend.${platform}"    : ip => "10.3.10.0", host_aliases => ["mysql-master-1",
                                                                                      "mysql.backend.${platform}"
                                                                                      ]}
  host { "load-balancer-1.backend.${platform}": ensure => absent }
  host { "backend-lb-1.backend.${platform}"   : ip     => "10.3.0.101", host_aliases => ["backend-lb-1",
                                                                                        "signon",
                                                                                        "signon.${platform}.alphagov.co.uk"
  ]}

  # ELMS (Licence Finder) VDC machines
  host { "licensify-frontend-1.licensify.${platform}"           : ip => "10.5.0.2", host_aliases =>  ["licensify-frontend-1", "licensify.${platform}.alphagov.co.uk"] }
  host { "licensify-frontend-2.licensify.${platform}"           : ip => "10.5.0.3", host_aliases =>  ["licensify-frontend-2"] }
  host { "licensify-backend-1.licensify.${platform}"            : ip => "10.5.0.4", host_aliases =>  ["licensify-backend-1",
                                                                                      "licensify-admin.${platform}.alphagov.co.uk"
                                                                                      ]}
  host { "licensify-backend-2.licensify.${platform}"           : ip => "10.5.0.5", host_aliases =>  ["licensify-backend-2"] }
  host { "licensify-mongo-1.licensify.${platform}"             : ip => "10.5.0.6", host_aliases =>  ["licensify-mongo-1"] }
  host { "licensify-mongo-2.licensify.${platform}"             : ip => "10.5.0.7", host_aliases =>  ["licensify-mongo-2"] }
  host { "licensify-mongo-3.licensify.${platform}"             : ip => "10.5.0.8", host_aliases =>  ["licensify-mongo-3"] }


  #EFG VDC machines
  host { "efg-mysql-master-1.efg.${platform}" : ip => "10.4.0.10"}
  host { "efg-frontend-1.efg.${platform}"     : ip => "10.4.0.2"}

  # Redirector VDC machines
  host { "redirector-1.redirector.${platform}"  : ip => "10.6.0.2" }
  host { "redirector-2.redirector.${platform}"  : ip => "10.6.0.3" }

}
