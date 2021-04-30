# Creates the leenagupte user
class users::leenagupte {
  govuk_user { 'leenagupte':
    fullname => 'Leena Gupte',
    email    => 'leena.gupte@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8vONfl9SCHP2LAr6W52Yk3FMw6+XY7TZv16dB6mvMWsJNi2RcH0BhuLKEZ57DMmO00cWSr7zL3E+X/PBT7qRYHOECFHNVwppZDIhk3k2chE1x1nQMuymhN+mTL2i2hRLlyjKjMsVjncknT+JKsU+uwnbDVchM+4D8vmUo8mxEWWci/okL3vgP0RdNu4kZSVMJxsAnRfBbzSDhAQk2Ce7O/8OJY6QV/4DKbARTk4PpS2pWxlYdyUX8O1bMTtnKsvTehpDHmNU0paW9kwYyVCnuTLkrpWOEIXkdnqNSvXRjibSFytiTGKD04U7zeVnkgwM5yB09FBlLawUVlj1Hkgfu3HIy/90SNsvKmc8qq8jiOqa/b/CxYTfM4Y3HmHWspuCA7AoNHXV1/a9GcSxW9SX0/i5qRC95dMs2YM0kzskBsvZ51HfbiOB8S9R1zdJkn/cfCyvndzdKM8Bi6MeCVDC9PwD+wzTlMTHemxhDIG5ZeKiKBoJGchNDbmA8uFfCmpcy46S+00ZLBoTvFgPNRjQGV+cVWekELpWe7oz9d87xqKMfkqnEKtYGq467C+vzvn6kR7mUlEWEpZi3wAN8NCHq6zjf6JvjiGbj5h3MZLA7NuTA5lZ4EVMR+cKDp9Lb4Vk+aNYSSJzciCegPQYChUasWnvZOui/5EaHhhVNp7hI1Q== leena.gupte@digital.cabinet-office.gov.uk',
  }
}
