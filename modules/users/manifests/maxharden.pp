# Creates the maxharden user
class users::maxharden {
  govuk_user { 'maxharden':
    fullname => 'Max Harden',
    email    => 'max.harden@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCt8FMNpEDHcAEY+RWqorlSuG0cS6zOAeu3l9nywy4D9HjXdL1BvBiKLhyVzyOF3+xgtb+pbr6ACxkUyfx81YEae8iY6jjrRcGLc2AUKTQ/emjl+Uns9KFsUfgpjqPloFAxtd9TVCpjtUKvv+eHOu+4yhirHv2rscr1xJgNwzbdaupeRnl1j8Jk7mr5Y48iyyLNzqi3tK6hqRN1Jxjjh2L6HDlmER1sJzZ1YlXaemKu2Pc2nawALNrzCuZ5sN5WnFFR36DvUYvbtz7wFs2fFlPX4/LIuypG6Od8AB+PryGlCd5yekh6SZD8I5VDI0AUSBj2hNF+akMGqmXhdYgGuevllYjJAoBp29nh2zCzpdEb8AROwKbDU41Pl8dqFacdMI+034UGyOo72US9rLX250OYa/+HNNb4DWktCNvvCJrTjYud/i2refIhhqJqPnhy+ssLA7x/Oe0MpAMaToQzqr+/KiHHc0RWW9ko0g4HpBHqAbxurl4UesIhdL2a3Bl2PzkqtQyubp1PsRwR2oOCOBDukdG6OSLYLSlBgb8Uzw5oT/J8Zzyp2qYVxhwrent+LTY0bwmrcTn/bH2lwX6sWke+UpyIZucajrfpVil4MJoFpd+Pgnq4ode6Zw5MVde7gZmBxYCW17KMJkKsI6/qTXW447mq3tC1FRTRc51+zeKkYQ== max.harden@digital.cabinet-office.gov.uk',
  }
}
