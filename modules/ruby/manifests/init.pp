class ruby($version) {
    package { 'ruby1.9.1':
        ensure  => $version,
        require => Apt::Ppa_repository[brightbox]
    }

    package { 'ruby1.9.1-dev':
        ensure  => $version,
        require => Apt::Ppa_repository[brightbox]
    }

    package { 'ruby1.8':
        ensure => purged
    }

    apt::ppa_repository { 'brightbox':
        publisher  => 'brightbox',
        repo       => 'ruby-ng',
    }
}