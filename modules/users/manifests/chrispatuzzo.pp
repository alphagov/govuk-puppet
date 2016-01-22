# Creates the chrispatuzzo user
class users::chrispatuzzo {
  govuk_user { 'chrispatuzzo':
    fullname => 'Chris Patuzzo',
    email    => 'chris.patuzzo@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbNxGtzthC9mxoIHswOtrRihLTCQ8I/gsNW13UYykk6wHaZAbTaienTcmDoUFc60kUUgNu5615CD9rGWTULk/ZqjAWhFWmPL/Xk8TMKLGp3S9U1pFkE3e+1kbN0uOfopA6UxJXRMvH7jM0PyKXNifnYFdIEBN2wVyGS0RhLWjOBsirM9KRVUk9aeSPSoEDUSXWJSCa9M4bdCJfTgEbeJo+IS6Pv+ndtTVrGWXMXAOT1Xi8iTY7lkQOiO1iJjRfBKWM+ibMg1M0i/FWZUl2BnMK5fasJFd2zIGfX77vEEboLFg3WWPQK+wGC7Q+8V0mGtbtJgGfN5DbpmHJ4CYsakAzzGuggEKc+HUTBYLAAAenr5SiQP7H364i4f5Ir2DdrMynS1NfjOitLctTQIW+Ovx/8RWbKHwaKZRCzJxjoz/haJ+64NyUzF5a78hTKiKDlhPUwYrp+TdiFCAcTzxSZQPtGwc8kxumHeKhQz8uqId2A3tR0MXcOdfanRvOKCRbob1ymBt1edxCQVrsR4a3Z2pTqqkBuEd3QI0gTQO8d50JQybVZ5dZqNPtBjN+U+hKD6DRlZdrnIvMlkNf1SQWJCqaXQTzdT9XCPZFWuTNCH/bdqGrMZv85UGbEpRth+Y20nPVioJ74IMPsTmTdSoyM/fgSiAdYsO9GxTpLdz9cmFmQw== chris@patuzzo.co.uk',
  }
}
