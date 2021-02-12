# Creates davidcliff user
class users::davidcliff {
  govuk_user { 'davidcliff':
    fullname => 'David Cliff',
    email    => 'david.cliff@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqXjcdnD4NLCCgmYRsee/PwN9yYFswcojkOX1QJ59cnnLw8h3YnG5BaFvEMk04f4SB+sxhIFBnqK6m1XbVF9/u9KL2Bo6Y2+cd9UT166I1nWPsQ76n3z8ADvqECMgxbJ3Vw7c6llvA45GvMjiqleBBM2D3GmMVtl0OB8z4kr5EKWh5TtPWkYMlYbjOpHeOifeDA5VOUAz76+9CFb3Mc7gzouAgZlTeb7LuyX4SmSC4fJ2sUjCbRd/alMu83wuKh0q5POpv05EKUvxzSwKsnT0HNwtdVhHiXtYUpCwxljSfa7UIW3vywYxqghmzJzrZWxotALFVWrw+thzknl3+a172FUhkIJ7sW7kl/HL8OgvV5bsbMcgWvkUGDmQzftjNLXTtIXNNuxKYX21OL4EXeMHikBvDLhD9YZ3Sk4dVdcuuyD8y73QAGE1qUZyUIuxNMMz6HyhB6buBe/GNcsG9iKlqyBDVZxM9zT3JxwMUOk2QHHxsxcgosvih9nXL5Rzj6BuLAj/MOP4+4mxslYvDb+MwtJSdM/t3PkPfg2YbiJh6rrStiGGTm0BaEVveAYROlHT4ULRp3oTWCyk9aQ/RdMECs+mQ2rn4ozwmJPdAO+ZJDn9YKERDxdHYlLen1cO2gs31wi3TCnwa0fjjYaCHDWzUswIp2NDSXChpTVZjzKoEvQ== davidcliff@GDS10099',
  }
}
