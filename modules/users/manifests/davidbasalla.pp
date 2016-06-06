# Creates the davidbasalla user
class users::davidbasalla {
  govuk_user { 'davidbasalla':
    fullname => 'David Basalla',
    email    => 'david.basalla@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKCMWzKj6J3M/a/6fpLymX/D8cr6mNiAP5Yz90pWwNs6ilAKl+aRJhErVUolkbduTY2e2/5rZTboUBOc7Z3jKQvNkSuJI/CLNyEPf+/1mv6UHhHqHsJxgU7LYG5NZJ46VSgxiLsKHIpmmkx2Y3H0P989D6+0+QClyKwYVuXv3b8dwfuorPNDUD4DGLPV35Q0W22fkF4XgpBt08OtnQhJmOnQ2+eAXXw/ogFGFtK0N5aHsBA/pgXdf4G9bXkJWLPU71VFtCnP9jaMRke7YjzoagpFKJZ7J84ndshe6RpFNQhxvQDKcf16fwMPVq+JBvl5epkv376ksJ7G9INafw49JQzsl/hO4g5l9v6eANHyKIHhqZgdk6M/yu+D+uAqGz4AK32YJlaGNceJ2i+DBO7SvIjmwC6jkv9KOwdproyWIB63nb98wT2h7S/p/2v0dRPW8SsfwCAo/sq7VSBQBESvDR+E0pVcUCGQwr2j/uBTChdL39LbpliMoNM/A93JBqL2dkycTIIP1gpnqNuK49oY0rxo1duysu9KMWzJizx5KaUf0aim0e25cI2uMugdMb72n5A3pL0JaZ7+YmaXaJ/zXu9qE6zuEfzYid+LsjRDsaVpH0nXcfEswW6avzoIaN9VaX3ahapfLSotA5Gf9pg3Fzmyyafhr2oXufxnPAoVnm0Q== davidbasalla@gmail.com',
  }
}
