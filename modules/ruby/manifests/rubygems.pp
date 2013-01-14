class ruby::rubygems ($version) {
    exec { "rubygems-${version}" :
        command   => "gem install rubygems-update -v ${version} && update_rubygems _${version}_",
        unless    => "gem -v | grep -q '^${version}$'",
        logoutput => on_failure
    }
}
