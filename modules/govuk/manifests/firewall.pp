class govuk::firewall inherits ufw {

  include ufw

  # Collect all virtual ufw rules
  Ufw::Allow <| |>
  Ufw::Deny <| |>
  Ufw::Limit <| |>

  # Temporary fix for http://projects.puppetlabs.com/issues/15534
  #
  #     err: /Stage[main]//Service[ufw]: Could not evaluate: undefined
  #     method `each' for #<String:0x00000002e68d20>
  #
  # NB: when you remove this hack, please also remove the inheritance on the
  # ufw module above, and remove the line in lib/tasks/lint.rake which
  # disables the puppet-lint inherits_across_namespaces check.
  Service['ufw'] {
    enable => undef,
  }

}
