define postfix::postmapfile($name) {
        exec { "postmap_${name}":
                command => "/usr/sbin/postmap /etc/postfix/${name}",
                refreshonly => true,
                require => [
                        File["/etc/postfix/${name}"],
                        Package["postfix"]],
        }
        file { "/etc/postfix/${name}":
                ensure  => present,
                mode    => 644,
                content => template("postfix/etc/postfix/${name}.erb"),
                notify  => Exec["postmap_${name}"]
        }
}

