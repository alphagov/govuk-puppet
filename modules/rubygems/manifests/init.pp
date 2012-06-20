class rubygems ($version) {
    exec { 'rubygems' :
        command => "/usr/bin/gem update --system $version",
        unless => "/usr/bin/gem -v | /bin/grep -q '^${version}$'"
    }
}