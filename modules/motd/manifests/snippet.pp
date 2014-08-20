# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define motd::snippet {
    file { "/etc/update-motd.d/${title}":
        ensure  => present,
        source  => "puppet:///modules/motd/etc/update-motd.d/${title}",
        mode    => '0755',
        require => File['/etc/update-motd.d'],
    }
}
