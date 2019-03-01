# Creates the kevingarwood user
class users::kevingarwood {
  govuk_user { 'kevingarwood':
    ensure   => absent,
    fullname => 'Kevin Garwood',
    email    => 'kevin.garwood@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRZSJfOMMpyzLvJZl1Gde0nhAFAPx19v89F9RR6ipGp1R/u7vEHqz0HwIwsh8bJCIj83Q/+riMEMJ6CZ5kS/ALV6TGCTU87No9je+cqGkJeoMxT+6tNASRAXPIgl+is9KsPxim2KKLk/XXQXS2pX69MgzNT2VbwiClRswZyscI0M7FuGIUKaarwOvYii65B9QjHwHfkJTrXbHIAiqZA1+u9GCc4zFo7eD9cQR0tyfWBLzCNlpkoTnLyB8yL4TkTgFJjElwaImUt36ZAFU9LbDvxwEAWWwFsq46LHCxb80D2EODZ63s6F6RAgNrTEQHNZoVWzfjPaBPQXYvCKlb/RKJ6DRlHpkpQ+klJiFpTmPHHSF+qgae84O441B7NCbHtPxWN+nBZXRnnKgpDQJfee2V3U376/gpDTqxFuJ3J2tE9JH0gQfe/vCsmQ3cIU3DL5nsYlcBHWb1NEdbi3an313HzqUmLzp5TwF61MsoFpWgGYFwwfJSG5WlpodACfv0Tm/m/OhJ/dPf4lpZWJ28yEhrFEnW3uSo1g0DWhw/IMiIsLrPsoKS9sR1lK+x0hALJRdp15p8U3mb21myi4Y0eZcA+L95fmzIPu1gjI0XDqkR2BA4uy2kGFVLp9mk8uzee/C2h4YnKAOmjQKodn9DT/IuBfV7Zo+fc76I1p4fPUlO+Q== kevin.garwood@digital.cabinet-office.gov.uk',
    ],
  }
}
