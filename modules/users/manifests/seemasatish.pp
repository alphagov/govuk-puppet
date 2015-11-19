# Creates the seemasatish user
class users::seemasatish {
  govuk::user { 'seemasatish':
    fullname => 'Seema Satish',
    email    => 'seema.satish@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVwwMn6Lqet7VoQ4799gyFKZT98azpoQ/HDIkR4OlpfxJaJcpszXtYrIwDpYMaiZUU/KZU4REpc5x1GNVWeQucYe3fMRGmtz92MzDZ1P2aqrX05LCAebslIRl9sUStzJvcGm9LzCOZAvDcUVDtIx95uvrEIqyhfeRwtOKLnzzh+QTcru6SZ5NA0hz2wFugAZwZrKLi47IDR7L0lrxRyKg0lWSlCOtEv4bf1RQOQ3jLy2SxLG8lQ9CwAlSRyK772XZmnC+DK3eduLxNC4lbf5g5p0wAoXuuzTVQN1zMNvrlgf2ICOTrewcD1nlyoVz9iA3jJYBn3+jYAN4j3L75sjgDAO0pHDD1hmTgSTwXaFAnt/apuPl8aRsQhE8H2NecdCIUYmh+9GBU9dFKL2PJ9xBjvz3/wokCRuj3rG1X6k9UcWPC/PhShdu7HJ/eLvNE/0CQRfLhward1a1+oRmO6x1Ypbia2VaGQMoUjC3bnU5iLvADhoe6o52Adk7oRJpQVQf9OBq+jofAqpCwtO0mtGHASbaWmMCjchcL9/UI4okkww5R04ul4e7IOCTPpr+BQQymeX6GO361Z9Rx3HtHSCI5qk1QVSNdcl7KCRfituWKClek9eMmNjKszccpd7HQSD3nvEirOGUtKFHdPGFFPqu1GZ99m7x+M1hjp0YCc/ZASw== ssatish@thoughtworks.com',
  }
}