class puppetdb::firewall {
  ufw::allow { "allow-puppetdb-from-all":
    port => 9292,
  }
}
