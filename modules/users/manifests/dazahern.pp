# Creates the dazahern user
class users::dazahern {
  govuk_user { 'dazahern':
    fullname => 'Daz Ahern',
    email    => 'daz.ahern@digital.cabinet-office.gov.uk',
    ssh_key  => [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR6cTKWPWIgYaYquqQKJDMz5+2CBaKLX2nxoy3JhcfKAX/m312/Sw7Avbs40HJCN2R5bYVkyaIq2IYs12cmnfOkPDhi/LUy2M7UcFkUEMqNSgLJh6Eazn46KAJtzdARTXN/T7wV4Iqb6h8ok8mB8237/71N9YbeZN3lIzVTeV0EvLZGFSJer9T2ZkC1/OZelR1zBd9YOixddA3Cj8TjP0snQFKiKSSIVtHQAP9ato0AzbsgVWSV8SpsqxkiLAuM7VR5+UVHR0uSxTeUllEv1N0oGRwCQTugoM35zsKMgl46vxeQ9TI+B+e6W6BIG0zTdYhK5KDTy1jtwnuz7XN+prTQn7Fe6vuSnIEx6NkBdisflRwj1UzC2ITevxssflNcarslFxSww9P63j3bV1c7mfKyNEoG6nUKWzx1lSwjnbYuzi4pdIc7lLoDNsGCTLa8Rvpf+/1+/qwdJP6LwC1NXpn0ckDoZA1AmWze0CoJUg9j6mpgSE3y2pIjdW7mmQzC1Lz51MtdvVgZqhQ12+1lFK2/tIL45PQMIxRS2YIM00KFWfF54MpRfskcCAJb4FY4nCYVGHAZt2k7mRUN3PyhrCC2n/p+gaB8yOKvOOft19G6dKagYdahjstkgwyP22wGW/Z2ltuDTytbIZASp0Eun2PfvzjhzayQ5oJlaOnb9nM/Q== daz.ahern@digital.cabinet-office.gov.uk',
    ],
  }
}
