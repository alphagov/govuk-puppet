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
  Service['ufw'] {
    enable  => undef,
  }

}
