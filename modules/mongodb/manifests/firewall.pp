class mongodb::firewall {
  ufw::allow { "allow-mongod-27017-from-all":
    port => 27017,
  }
  ufw::allow { "allow-mongod-28017-from-all":
    port => 28017,
  }
}
