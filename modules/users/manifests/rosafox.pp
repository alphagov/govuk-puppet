# Creates rosafox user
class users::rosafox {
  govuk::user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/iFVHaFNWHDOcU31p0jimTkC/9R4cBNPYMBkKf4s5c0tPkMjs7ICi+ou4oauHiVKpBX1YIaF7zk+UnFpoi/UKeYTnjp27YeHDhjW/koaRlaUuTUCPrWmKTgsPPRU+7eeHcNXk+cAHI0ihMePDOiPT1902+WGGJ74mtHfMfQT+AzqmSAOVbBtOA5/H6donRiDoie4b3o7kG9FHvbdur5cIO7KoZzJsORX8ehrodDcfaI0avSkrciE5yM8EQY/1/9BbKEWqvFfUXL+XWejkylbrB4L+Py6Mc3/jJHp6nUcXDeZ1jGUYOWwnaJwag1Rwil/NQ+rATrtnWj4Z5YJC/shSMhwYxS8m5fMmL/SI8mjSbLGwdFZ68hlpb7Ex5ATJWOCyZJl8ujBzypB6KWFSVWrkICHubNvL+UUbfipjHZuVTbC/gEbjtq0Rt6/rFsU5aGFbgyP+2dkO2PpoCMPS38ZA+qNgpsiuQTetx5IyQ0RF9XD0DSUUUP1Zjok1c5xEcto60otDtXvl6+1sogD7LG7oRbSt3aPFbiCeEV0TwjToqSkGfy/KCXk+HNh13nFQ+//PFtOPS3NiYXoJYNoficRdER9mFwFFDvqQYxfJI1KeSBS6A4dpyxU1NiLgT2iBmmwp7u1/tyVQON0EHDphlACCKqupWSbPqa+NviwL5qApbQ== rosafox89@gmail.com
',
  }
}
