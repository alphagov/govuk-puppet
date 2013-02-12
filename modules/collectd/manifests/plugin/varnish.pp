class collectd::plugin::varnish {

  if $::lsbdistcodename == 'lucid' {
    # Soft failure for Lucid. The package we're using does enable Varnish
    # support due to a compat bug. Upgrade these nodes to Precise.

    notify { "${title} not supported on Lucid. Omitting plugin": }

  } else {

    collectd::plugin { 'varnish': }

  }

}
