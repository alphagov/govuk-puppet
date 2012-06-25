class ruby($version) {
    package { 'ruby1.9.1' :
        ensure  => $version,
        require => Apt::Deb_repository[brightbox]
    }

    package { 'ruby1.8':
        ensure => purged
    }

    apt::deb_repository { 'brightbox':
        url  => 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu',
        repo => 'main',
    }
}