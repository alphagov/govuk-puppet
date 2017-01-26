# Creates the dazahern user
class users::dazahern {
  govuk_user { 'dazahern':
    fullname => 'Daz Ahern',
    email    => 'daz.ahern@digital.cabinet-office.gov.uk',
    ssh_key  => [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDl1JnmypFtlTsy+rLhCuWdtZd0kSlyogtKJi2Ax2BVJ0RMsP7Ni3OMtbTAZ85QZ/qiuBPS1oNJwc/XPkCdWBh6MuoDlunAEwfvqPr6SalqgWB/k9QoxHd68knr/YqX4hB5Zhn7TbGFdIc+QEuN/+LsLp1I7PKCNRzu1pEK4svufL3qJ3PXUOE+bjathFH7JQe5XAJyw41JgwDA+2Fr6t1w0qJ14UaJ9Us6+k59YSfxoQMh53MN79NWnJb6yVE9u7omuJO8TkcPcLZWiVgZoo7TfXZsN030ykFTExZhFqaBWQkK7w3quGY3fQ86pAcv+ITbEwOP0C+NousCL9R29UH daz.ahern@digital.cabinet-office.gov.uk',
    ],
  }
}
