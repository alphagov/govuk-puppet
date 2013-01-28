class govuk::firewall {

  include ufw

  # Collect all virtual ufw rules
  Ufw::Allow <| |>
  Ufw::Deny <| |>
  Ufw::Limit <| |>

  # The rules in this module are based on an audit of all ports listening
  # for our EC2 Preview and Production infrastructure. The CSV describing all
  # listening ports is saved as port_audit.csv

  # To generate it I did:
  #   fab preview sdo:'netstat -plant | grep LISTEN' > ~/preview-netstat
  #   fab production sdo:'netstat -plant | grep LISTEN' > ~/production-netstat
  #   cat production-netstat preview-netstat |\
  #         egrep -v "(Disconnecting|Executing task|sudo:|^Done|^$)" |\
  #         awk '{print $3,$6,$7,$9}' | egrep -v '^tcp6' |\
  #         grep -v "127.0.0.1:" | sed 's:0.0.0.0\:\*::g' |\
  #         sed "s: [0-9]*/::g" | cut -d: -f2 | sort | uniq -c |\
  #         awk 'BEGIN{OFS=",";}{print $1,$2,$3}' > port_audit.csv

  # Monitoring Suite Clients
  ufw::allow { "allow-gmond-8649-tcp-from-all":
    proto => 'tcp',
    port  => 8649,
  }
  ufw::allow { "allow-gmond-8649-udp-from-all":
    proto => 'udp',
    port  => 8649,
  }
  ufw::allow { "allow-gmetad-8651-from-all":
    port => 8651,
  }
  ufw::allow { "allow-gmetad-8652-from-all":
    port => 8652,
  }
  ufw::allow { "allow-statsd-from-all":
    port => 8126,
  }

  # Monitoring Suite Servers
  ufw::allow { "allow-amqp-from-all":
    port => 5672,
  }

  # Webservers
  ufw::allow { "allow-http-from-all":
    port => 80,
  }
  ufw::allow { "allow-https-from-all":
    port => 443,
  }

  # Routers
  ufw::allow { "allow-http-8080-from-all":
    port => 8080,
  }

  ufw::allow { "allow-puppetdb-from-all":
    port => 9292,
  }

  # Puppet clients
  ufw::allow { "allow-facter-from-all":
    port => 9294,
  }

  # Support Server
  ufw::allow { "allow-apt_cacher-from-all":
    port => 3142,
  }
  ufw::allow { "allow-solr-from-all":
    port => 8983,
  }
  ufw::allow { "allow-elasticsearch-from-all":
    port => 9200,
  }

  #Load balancer Health Check ports
  ufw::allow { "allow-loadbalancer-health-check-signonotron-ssl-from-all":
    port => 9401,
  }

  #Load balancer Health Check ports
  ufw::allow { "allow-haproxy-health-check-from-vshield":
    port => 8900,
  }

}
