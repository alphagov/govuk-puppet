# Creates rosafox user
class users::rosafox {
  govuk::user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDK5pZu53f5NCmdOfvY6jgINfme3qLl1NtMHPagJ2TTxDMyieids44XPip8p1+raNjjyvoTQKEGnZJLtvc1+Fls0+efoWatQB23MS1J4qH6fWiukQwhd8kkBlCFud33iSXAHHbP1qKFY1g1qdIGnOqp8WUzN42VVaIpkoh2CdO9DCQliKvsqEPK20zF6P0RcrtYVeNgQotLyL16soVSe0uQikIZ3AcvONDu6OAJ2E/5GwSpF8ZQNSE8C+8lf5PZXpZBxPbZuOoMCXBXCpnpVvapalb8Tm3Epq5npzT+Y0OXWlPpGRkytmWRASZPJ+3SOCiJTK6YHgTcfuU8akGe+m4StZzDh7TkmdBNN7nTXgyeraEuPFFHALFjeWPyID/y8fpNJTgaY4Qil40klFheKG0NlxCQ/KB7ELhns+dTPod/D/CX3SrCjj3fuSubrR6rl93YRT0AvqInJI94WnRezBmljXyVGuxcssM7W3IU4TonMLBQgi814EZTE44QkZYJukvhzaTQBZqU2u3iMCgBAVCyGx2uSPj+o4JO/UMlLRxTvnkY5f8clPzjTDB+vgELNL0Y5K+SWAsXdhky8A7y98in9AGQHvouqOT1ND7Hv9W+nybgPzMN06/lrbRmv0TkHqOco3J+8EqtKStUI0HjaUO5nR7FbS2QBizanEg9T3HypQ== rosafox89@gmail.com',
  }
}
