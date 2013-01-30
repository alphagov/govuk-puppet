class ganglia::firewall {
  @ufw::allow { "allow-gmetad-8651-from-all":
    port => 8651,
  }
  @ufw::allow { "allow-gmetad-8652-from-all":
    port => 8652,
  }
}
