class ufw::govuk {

  include ufw

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


  # SSH Connections
  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }

  # Monitoring Suite Clients
  ufw::allow { "allow-nrpe-from-all":
    port => 5666,
  }
  ufw::allow { "allow-gmond-from-all":
    port => 8649,
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
  ufw::allow { "allow-graphite-2003-from-all":
    port => 2003,
  }
  ufw::allow { "allow-graphite-2004-from-all":
    port => 2004,
  }
  ufw::allow { "allow-graphite-7002-from-all":
    port => 7002,
  }
  ufw::allow { "allow-amqp-from-all":
    port => 5672,
  }

  # Database Servers
  ufw::allow { "allow-mongod-27017-from-all":
    port => 27017,
  }
  ufw::allow { "allow-mongod-28017-from-all":
    port => 28017,
  }
  ufw::allow { "allow-mysqld-from-all":
    port => 3306,
  }

  # Webservers
  ufw::allow { "allow-http-from-all":
    port => 80,
  }
  ufw::allow { "allow-https-from-all":
    port => 443,
  }

  # Puppet master
  ufw::allow { "allow-puppetmaster-from-all":
    port => 8140,
  }
  ufw::allow { "allow-puppetdb-from-all":
    port => 9292,
  }
  # Puppet clients
  ufw::allow { "allow-facter-from-all":
    port => 9294,
  }

}
