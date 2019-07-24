# Creates the julianstandring user
class users::julianstandring {
  govuk_user { 'julianstandring':
    ensure   => absent,
    fullname => 'Julian Standring',
    email    => 'julian.standring@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEWlEkKyLzpiSmLnh7IFA56yZ3+8Z0YekhVM5y2z1UatJyM9JQ7sesBFBcWlDp2mvGozxmtl1PaeLDzsBDVawVRmroY93Fe8j65Ir0izzADeEKPH2lN8TKeAF8/NFWlyl0Qm6bBxCUnvWgpoSG4QYt2iDACncK/zlr6vO6rtY7lcLo9Egnw/hW0M+HJO2fJ2MFFMhcPQwU2Wx7jsc7tSLbNWPnL1/e8CpEa5RTQn4a7/IwsFBQMKuTFAcpFzilgAqvpbXWrlnvLzTFhed8PO27SqLMKRSH9Tlc34BF16leSmJR2cdEIosORq0it+qzhj286cO75kUT7IbLoZHrh4lK4abp3kgGTzEsElckOh6jVHZ1Hg+VABrqfAQWRW1WlqmhQYlI2XtbqxpD6ouRXdeEVuyE3Ofboj/4nDX7yqkyIYk+jAR8tarcAM57e2xBEJ8f1bUAS5h6Hb/wVkX8c9T31NgrZCvJlhM8VKkIh7HoIAhXKsOrvVZvKtkA2q7vhcjFVxxCGximCIwNMCIWOU1E+d8CMXnLkl7pWIFzSsTxt0x78N9+1OjllED8dO3rFZlM5sMdLxfNITRKiIE71GoXI49hfkFlG1TA+GbGglLVUyFe83KwKuqfZIt2+i3LNqjD+ru2PhnbodenNj/FOY296F3rf/Hmbf5uwYmOXSCwUQ== julianstandring@gds3915.local' ,
    ],
  }
}
