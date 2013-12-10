class nsca::client {
  include nsca

  service {'nsca':
    ensure    => running,
    hasstatus => false,
    # ugh. cross-module dependency alert.
    # we require Package['nagios3'] because it creates the 'nagios'
    # user which the nsca process depends on. I don't want to depend
    # on Class['nagios'] because that feels a bit too restrictive - we
    # don't want to stop nsca starting before nagios3 has started.
    #
    # if you can imagine a better way of doing this, please do it! :)
    # -- ppotter 2013-02-07
    require   => [Package['nsca']],
  }
}
