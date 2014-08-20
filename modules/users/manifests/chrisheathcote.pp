# Creates the chrisheathcote user
class users::chrisheathcote {
  govuk::user { 'chrisheathcote':
    fullname => 'Chris Heathcote',
    email    => 'chris.heathcote@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIQ6tftq8RVFCw7As995DdBoxvftFMZGVCfltSmTINMXBP3eOZGWbYrvDqUykocS1FDoK5aE+toRxj21HQiVkbwLY07ks0o4bqIZBroP7tQer4j7PpWHqvwEYvw7P/8GUSTIDcD0qWodb4WqojV4YEFoGR1G3YxxBBB0fsNele/pkMl20Xkq25Y7CmsL+lNDQOw7Rynf0TJKl7qYO5ZULWwR4v5sioXeiPy9sw15sLLjyJRC4H4kuNYh6XsxsgYFV62N7u1CPNHPDJ7i/KGWZM4fI69FV8W1egVBKQH75K6gQznP5sPpqsD4Sgwn4tWcUWb+tUpeBsgPKxMsW7A9BZ',
  }
}
