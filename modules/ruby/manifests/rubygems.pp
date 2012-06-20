class ruby::rubygems ($version) {
    exec { "rubygems-$version" :
        command   => "/usr/bin/gem install rubygems-update -v $version && /usr/bin/update_rubygems _${version}_",
        unless    => "/usr/bin/gem -v | /bin/grep -q '^${version}$'",
        logoutput => on_failure
    }
}
