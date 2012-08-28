[![Build Status](https://secure.travis-ci.org/attachmentgenie/puppet-module-ufw.png)](http://travis-ci.org/attachmentgenie/puppet-module-ufw)

Puppet UFW Module
=================

Module for configuring UFW (Uncomplicated Firewall).

Tested on Debian GNU/Linux 6.0 Squeeze and Ubuntu 12.04 LTS with Puppet 2.7.
Patches for other operating systems are welcome.

Usage
-----

If you include the ufw class the package will be installed, the service
will be enabled, and all incomming connections will be denied:

    include ufw

Note that you'll need to define a global search path for the `exec`
resource to make this module function properly. This should ideally be
placed in `manifests/site.pp`:

    Exec {
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    }

You can then allow certain connections:

    ufw::allow { "allow-ssh-from-all":
      port => 22,
    }

    ufw::allow { "allow-all-from-trusted":
      from => "10.0.0.145",
    }

    ufw::allow { "allow-http-on-specific-interface":
      port => 80,
      ip => "10.0.0.20",
    }

    ufw::allow { "allow-dns-over-udp":
      port => 53,
      proto => "udp",
    }

You can also rate limit certain ports (the IP is blocked if it initiates
6 or more connections within 30 seconds):

    ufw::limit { 22: }
