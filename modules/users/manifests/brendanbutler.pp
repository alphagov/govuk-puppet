# Creates brendanbutler user
class users::brendanbutler {
  govuk::user { 'brendanbutler':
    fullname => 'Brendan Butler',
    email    => 'brendan.butler@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgBfJFAJ5hrxIkFQmrDDijHUzMEasX2ZTS1bHQQ2QEGEAg4gaLBho2ssgfsQu2XeO/i6O94GgPydR/uC+yMfyo7AF8WTRJX4vwguAF6DxSQp7qGVIZ/JX0zH/V5YsG6cp10iePvBokonNdHDGXYbD5wndnkA7t/G7I58rGZgjtRG5RGIYtmLM9Pb3aSFeEuSmfbQbGE7ASf41hnS4OLwCyg69Tmv7B+fSq3mRFNqERCn8MHccEYkzlvzjRhVEZRPrIWqPiMpNmtdLt5/pgiQdst/ii538Br1Cn90vubsOFLCgzC9O6G6hGWd3Y7tMCCBGivInUGdN2ujI8J0j6ahE/QtqvHtAa+47a2IO29DD40muaZHVF/nyM/QLnvaoB3ypZHLvxkvIPUYqugKz9sfQzNqIrrlj37K1Mgek4yi1GO5P8GIJyx6EWVvoBDt7mRpCwl1wggFzDE6i1TQGheyPAMWjdLt1OCdKKFBB4Nmr+9nclBhVNXKZ6yadaqNsmyZpog6WQjSqC1cot6qezdc0KHkQiDxqJq7gWWWAGAOnUnD4eUxY1+IC69iLo+Y80jAU0LSKmuYKGr0WBqgRa/xJrGObbmYrJy1Oc9JVloIpikBoEqm8EZx52Yhyg9kAygKhVEkRAa47GT01jUbhG7JFdY8Jil5RP7ysPPqg0PLM4Gw== brendan.butler@digital.cabinet-office.gov.uk',
  }
}
