# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::firewall {

  include ufw

  # Collect all virtual ufw rules
  Ufw::Allow <| |>
  Ufw::Deny <| |>
  Ufw::Limit <| |>

}
