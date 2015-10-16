# Creates the tombooth user
class users::tombooth {
  govuk::user { 'tombooth':
    fullname => 'Tom Booth',
    email    => 'tom.booth@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxk09iuHGNTgYMMuda2SKjvKaVsq7y2KRk446UuYqTePrBYRGa3wqkiCskyOO1DyKDQFVvHRXxGYCAfE1WEpUYHDL7ihrFG0FUfndA3cn/mGS/UEiIq1Lyo2kwr+Yk3SjlWSbe4DnjnxO5S+5LjsMCuN4Ojla5CqRrf3uQ+4KLvriQBJvA3obF34WQ7IuPQYrKvO8aJaEuQrZ9kUY4q97BJ4iJUCtia8z/S5N0xpyrjBTxbb+dzUxb3/QxRUpOG8lPVMTzeHhRcoDXpj3olHOPgzVqH2r8dIPGwUla+8kBBjow6JnxWiBNbyv6bNA30tstvnt7TrbM889IFdAwTAAuJysRP+NU4eDTm4zdRCyWP3WFTDxAre7n20sIBkc4wLwc5ujvFDbT1QUEGoCg0EjwtRMmBgsZUmqinb2glsJRFezxaHQPq4g5k16uTRcdLNTD6fK05PkGXhdyb02DTw3jH+xkCKTG/nndP770yyb8rLM27V7/u8nhaxreGJegAe1DJ+IPsYRyRn5G/ZNUPQX7Wc9RrsGw5xNk7kCheFCcDB4/ZnyiGtOIoe0a8VMRDswp9Nw4ixwU8ehtPnWTmB79jnMV6gkz8MhUkqGqeJO7U0joekZdOzeGFEvePx/wKM+rgfbCd1qY+thtwERvWr6v7pQ+NLGuyuQEp8TvMwFVbQ== tom.booth@digital.cabinet-office.gov.uk',
  }
}
