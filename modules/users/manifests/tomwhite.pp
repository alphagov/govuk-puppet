# Creates the tomwhite user
class users::tomwhite {
  govuk_user { 'tomwhite':
    fullname => 'Tom White',
    email    => 'tom.white@digital.cabinet-office.gov.uk',
    ssh_key  =>
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNLrA6sAGHrmbCfvoDh35TEk1SFPUR96uUev87W40eMpb9WIVHUi9OKZTs9dNMoCNioJDSnkuauYv6k4pszCD/lyuKGt5Q/2cdOKyvK/+5ObqXDAzpLRzCmh0EgAJqNDKKKnevbMyCRtca8qMkACxzTZmydCBluPXKp/T+c2jE5Oip3trDBjHCdqYh1zEfbhmlkAeLYZAetYulH9inII+UC/5wELkohxljIKAaBbicVYURqYUObN9qJvVzSXbVsvr1OvfgHEv1zHclm1MFVMxlZbjUUXnyfO+W40tG8P9QoG/2b5QjoDuoTg/LAyCjgw0eCmMQj4G61+qg+C6K64MAY7PdG1D3V/PWM0G9WRFVfDiRX75nkzz1V1eZjfbok9Bn/J6n27O68Y9Fblu6WYsHSLHKjzGKfXPe11iKAyNEOGqgsJhxHuju1SOo6UfqbX8lgskibh3YdP7h6oa5gVIrCxRVSOnUNU1Pbepj2yLCjBJkwtesIeKGY28Ek71q1zQq5uWnD5jOOtUNSh3JZHLHy/lrQLQJGlI+EPb7aou36pWxzr3gNRyJLjJGTQCGAxn7BcorWKbztkV9QEKT2U4rstUfzilD3fSGEtLJeEOi7CcgCHRUHud0nzM6pZuVGg/KJ+CB8UlbupcTNhulfFf5OhtitcGVTxyS7QKISPy9PQ== tom@MacBook-Pro.local',
  }
}
