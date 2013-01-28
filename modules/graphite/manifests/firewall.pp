class graphite::firewall {
  ufw::allow { "allow-graphite-2003-from-all":
    port => 2003,
  }
  ufw::allow { "allow-graphite-2004-from-all":
    port => 2004,
  }
  ufw::allow { "allow-graphite-7002-from-all":
    port => 7002,
  }
}
