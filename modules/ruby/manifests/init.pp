class ruby($version) {
    package { 'ruby' :
        ensure => $version
    }
}