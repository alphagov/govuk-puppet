# Creates the petergoddard user
class users::petergoddard {
  govuk_user { 'petergoddard':
    ensure   => absent,
    fullname => 'Peter Goddard',
    email    => 'peter.goddard@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDV+V/+VgBUkTPsqrhKepBJ2K2icaDZweed0V/w+EHgOMBWpnw07QN31i6bt76I/WFDQxskSLk5lkxI8yHMVgHbUz8PkyVTEDC3ZLTwuMuUwwXe4nQdS7rHIdtexya5a6Bme2LJaGYA4dxm7QAGuzP9u4AomlL1HrBWAKo7wxvpovIB3pP3R3gc6Q+9SB79uHjpeBcNA0VvrbfDvh1FRlE6CM+6bB0dbRWwWbI4XLVrd8f2Ympqt1rmipf+x1/8JO+fmZmfCvDt2oAcr1iVqwJeRYitJJDpJnfk12JPcFoIBMwOJJSFXYkYiya4iNc66Jco5f9nQqHHi9yyAX7Nt2tIBY6DWoDrdLIYUtVNAYP/OFOhZLKbm/df23oJ65UYg5uNt/brDYM6VdWbZjTvmxwZQfpOCGZAswZoeVZplmtgPlqt30rud0EXIyuxvF/XF+0Ehpj9XG+yrGNMJ9JR+lX3Nr29vy1Gc3UIIRGMLibl0KQBcr6izxeM/0YnLqX+57pvUvnl/BTl527TgiXm6OuhkejdJt2o25FTegZrLJyRiD7IEnd/qYheGTcYNdVxibkYTHjKHmjuKWAi5w+7d+iMHuOlr83S5jQsKE6koOVDPXGWvTpJVwCykK6/QqhMrUqK6dOIK3iDTJ3IPrRcv+Ep/kslukFTFAT51rHCgijZJQ== peter.goddard@digital.cabinet-office.gov.uk',
  }
}
