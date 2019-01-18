# Creates the user dilwoarhussain
class users::dilwoarhussain {
  govuk_user { 'dilwoarhussain':
    ensure   => absent,
    fullname => 'Dilwoar Hussain',
    email    => 'dilwoar.hussain@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG1b8dkrfJxBD1WruOrjIGQ7gO8Kj2IkxH4TpoAp5T4YKMWr8k0HF3nNC8UvZpmDF3emsp9a8zzqJemrqYsG7Ix266J0X86rRajViQD4Dhup2m77skh2Ioa2G+Zi+/K/oCacb5UsRKNYAWc+/Lz85rf57Posh+IYrrF4HZlua13UJKBp63nx7BECu3EYVOM7QV4+dFaI308lBCW0Bpj5qENhB9x+fCNA4nTBK2znFtyMfhv2ydevoTFsMxbKrApMNRxS99sGeLkOHwC6bQrAk4dKyyJ6p1k4h4MrabTHSQWd9++Bz1a/wJuQWLoxaOUIDaEEB3gY63citkQZhaYJELeKpKANjJjn4Y74+RvZaGYqv7/zPN5Z5I9CdVRJ0UJUa1X7iuSMk0pyC73afIIIOA6YQXhoUgCx7R53uNCAGXsNN7l9pAsK+JIuCJvJqK1omFUc4hzKokLfkR4ROynp6w8rYBc3/U3hCt0cFEiaacb5TKJhp+WNXuMLj+AH4Cax1BibfEz6+N3bvT7hf58eqgk2PrlqxJTIL9rCp214sFD0EDaOPJuZSCXYSaDl8d3G8AEbzeUQQah02nuMGFX/MAWAB1spPfwds/av3uAL1x2kFPBch8nx2OyIIF4+G0Vk41PCIsT7tTr51MXNw4TbYGl2Hrj4r4dyfxaKd+v1igSw== dilwoar.hussain@digital.cabinet-office.gov.uk',
    ],
  }
}
