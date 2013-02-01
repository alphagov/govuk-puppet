class govuk::firewall {

  include ufw

  # Collect all virtual ufw rules
  Ufw::Allow <| |>
  Ufw::Deny <| |>
  Ufw::Limit <| |>

}
