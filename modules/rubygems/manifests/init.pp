class rubygems ($version) {
    exec { "rubygems-$version" :
        command => "/usr/bin/gem update --system $version",
        unless  => "/usr/bin/gem -v | /bin/grep -q '^${version}$'"
    }
}
