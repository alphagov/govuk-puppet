# Creates the andydriver user
class users::andydriver {
  govuk_user { 'andydriver':
    fullname => 'Andy Driver',
    email    => 'andy.driver@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfAMf+4udHD6k8H8O3XLWZ3MKT7iRkDf1tpMc+kTeLHHKM0xcCDlU9NikQ+fkS9WifPRS51ojFVv2J7xKAajSX0UCsChZxMsUdbwYQPBEx1r/vAUn58amcNqdOpXkppOhxcdfkqIcotbOqux9bEjSLwet/q2s/aY7X5qDDagxfNlZ/ki1libg0tGPzmgD2Sq90EEzlyYjnlbFcyCQRi0+zGDnFu5ztVbPfbAepeNUaFO74KWxHh2XJAiAqQEUFT01Xt+ND40JGdB/t6pD7EtA4KpMWbTzazKF1rcjvGwNp4T05o8Emh9Pcem7nYwPm+/whNerBB8bFXeceSc6rZBEFCItLo+zC+ACY11GJmNqllHT3bzZ2jm28AdzF5aVX4rZ9hXjgG0pTNu8S6u1VOtxEOtMnZzUgNvX8skD/0fKB886IOr7RQ8+N3T92sV5zyzUOqMDUh1whQxM0ycW7kxdLuimbK+bgd72DcE79l64o4xWy3XKlp8INQRF8VC0JtC37GNFlOWXBINj9Ak+SL7YMHYeyBNbEuDPAWoKr/e/XEe2O/hKfH2Lu9QU14QCYvAgbmZfMtzUVEV1Ea8Wst21bZs2BtDDuKdbSdvzoduQ1QqUua5hX1zopcPfqr/huuZOifi/p07geLTXWosms4iEeIBNemyBusa1pKieOgzkMCw== andy.driver@digital.cabinet-office.gov.uk',
  }
}
