class nginx::firewall {
  @ufw::allow { "allow-http-from-all":
    port => 80,
  }

  @ufw::allow { "allow-https-from-all":
    port => 443,
  }
}
