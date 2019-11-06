# Creates the stephenford user
class users::stephenford {
  govuk_user { 'stephenford':
    fullname => 'Stephen Ford',
    email    => 'stephen.ford@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEBg2FP6ILqRLUYB55iixIjYkLj3jrBrAOHecxgQUXEsO9nDynSKEsb5KRZYVf7RoV0+Gw+IqhcwULYzFTwfZV5KwOfA7xUhVy6YxBluUe50DpfBXR2uuOkzrjQg6c8wO0Ce0AoECcItTr5TQUgIUqhBvqw+dcp2qgLs1MXp0NbvnaQoxr8Hu6cn01v/H33z1HBRGbPCYESGmqr4HAldJJ7zrkSVVLxB7U2yhqCimHUjL2EUhnD6MEz3fV/wLiWYOJYf/nqfKFbL530LxG9SDE3WdsqFZk8T3gmT+Q4BGQsPT8jdbAoyE5zA13LpKeDaJxjjiI/Nc+eD+hKb1CDevqKstCrs1f0kznxxQTksxxLErEmqhxovqr2k9CJAA0Q3nrvs7p+F9jQgcQtNLYvJWhU4/xUEfDIsDlzUnw3loGhtNsvm0qCAyNTDg8Km86zGp3qOMwSpWo6J+O5zR0VK3bKkIOWVLovKvM16OmcGz8Ye8IngNVtOcZX6sSBkotjR/l163RvsKADSie/foQw3F/4xm0zzpyUoPY2Fzm6o1yBZhgXwBcmvKd2X1uDlL7a9gLi39YQfCakuA4qFX2lqFo2Zv7kMypKQEVHRuUY+VwQzDSurLnP+qfb4rlVxoSYy5LiRcRlKdQHr+dDkpzx/5uBKHeQoMDUnL4pV60YEP5Nw== 20160114-il2 stephen.ford@digital.cabinet-office.gov.uk',
  }
}
