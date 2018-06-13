# Creates the felixharrison user
class users::felixharrison {
  govuk_user { 'felixharrison':
    ensure   => absent,
    fullname => 'Felix Harrison',
    email    => 'felix.harrison@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN3KiJl2fQeMjm5kWZIAfF35cE5C+MjtJXs/0suaXweCgnqWxMvlE0xaAlZ8KToLBSBoW1xyruAO8QPkwLQHKNtahjCnaqkO72xS4sxp49cQpTsWBR5uiuVbzAQ9Q32+9N89+OJLnuIy3WB9//01WVoTZCBOVbEZ72MbTrzx8G2bv7yCNutd7lEirFKCiBBY5ma0J3baYwmNMgtfRXtS8srVDLSU1NkZIb5cUOjMPUUkpIG/iuFkDUN7lkzzXEUcoUDVq1rmiCPatt9aC8gpT4BFaV2XEtUwx8NkfTxMpTLjnfoxOM9KSvZfLZe19qiFRuw30TLtWdqfyrI4rq7RRBQhWIrCDSnZbpDUUhdnFD2OBKbCYm1lsTaAE1updj/ulWN/X+/8I6+Ml2mhatjvVZljXE9XXc20Pob4ONAauzsZOEoERvfdb0Kr9xY8OhUtaMqieF+vdooJ9hh+sv00XIRWpyMKJObn+5tyjpkhCC2rm5X5XscsXPakSkguAa5bh6kvsqOn5R1qtwFsWm9inbePOH3mTbO3e/35wcYPD0xdO/BU2xC0FcCeXjCRg+5fJCWpa+1EuZE/+iWdHpgU3TodzGm8ASLtLQRCn6viXD38af7Fe9WS4fzTFd/oxKg0SSFspTZnLVnABYYhoCsGckf3rxHftaW2sWZgJ/aN3csw== felix.harrison@digital.cabinet-office.gov.uk',
  }
}
