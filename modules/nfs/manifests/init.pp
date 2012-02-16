class nfs_common {
  package { "nfs-common":
    ensure => installed
  }

  file { "/data/media":
    ensure => directory
  }
}

class nfs_server {
  include nfs_common

  service { "nfs-kernel-server":
    ensure   => running,
    require  => [Package["nfs-kernel-server"],Package["nfs-common"]]
  }

  package { "nfs-kernel-server":
    ensure   => installed 
  }

  file { "/etc/exports":
     owner   => "root",
     group   => "root",
     mode    => 644,
     source  => "puppet:///modules/nfs/exports",
     notify  => Service["nfs-kernel-server"],
     require => [File["/data/media"]],
  }
}

class nfs_client {
  include nfs_common

  define nfs_mount() {
    mount { "/data/media":
      device  => "$name:/data/media",
      fstype  => "nfs",
      ensure  => "mounted",
      options => "defaults",
      atboot  => true,
      require => Class["nfs_common"],
    }
  }
}
