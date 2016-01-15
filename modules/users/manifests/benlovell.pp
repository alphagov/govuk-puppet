# Creates the benlovell user
class users::benlovell {
  govuk::user { 'benlovell':
    fullname => 'Ben Lovell',
    email    => 'ben.lovell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYeDKSeQHYityfaL3hHVUG1ZqMhIrs1b114hZotHCJApOtkPmTObmtw8UWFIfMtPmFMojLzh7SVTWjbHPwNJW2TWGj3WKwV+NOp5Bkvkm6lyhlDDAR17SsA5v0KIfpXDlwojaiBR4x5HAbVkou8m5QgASHRAgTHb2WuZuaTzD6Kn0lbpgzG6uFOJA2IkhjFlmYq23Yzn+lxeNR6uPFtUdsb+AyoKO5zXj43SAi/wI9orjlGiE5X097MpiVmvz8xfwuy1Py7mkHJWhtOYqox9kfY0WsCMxgnQ9e0fm2YxlfDU0/sET/r07crZohF7reQMdNWsTdBF5dkmArB6bOtVN2U+cZcD1OAN1qI8eZ/s5PE5MBq8Ky7aUr8XV1oX0QRYomrn1xGsrPldFj9+bxh22jkjzFm06cy0++md6pucjtVZX3kvtBTea7tcaYRHSquUAVjiDfPih5rlTz3Utkq95pHafvw80+MbpFYR56cAZy+mzj8biiF34GZeEB4mneBvL03TrQENtbOU160IGQfnAEL3L3VIzT2q2OoYKnmghBwiOXfAVBBATdzL6OZiOLpCalv0r46ou5gkjkpCNyTDV6XPpnQI66UR1o84HZefgwOIkF2ZNJb4Ll1dReBhCWkMC4B9l15SIqHQWOGNRCeIMZroASU9s40tikyyUU+O4SJQ== benjamin.lovell@gmail.com',
  }
}
