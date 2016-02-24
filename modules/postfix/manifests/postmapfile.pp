# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define postfix::postmapfile($named) {
        exec { "postmap_${named}":
                command     => "/usr/sbin/postmap /etc/postfix/${named}",
                refreshonly => true,
                require     => [
                            File["/etc/postfix/${named}"],
                            Package['postfix']],
        }
        file { "/etc/postfix/${named}":
                ensure  => present,
                mode    => '0644',
                content => template("postfix/etc/postfix/${named}.erb"),
                notify  => Exec["postmap_${named}"],
        }
}

