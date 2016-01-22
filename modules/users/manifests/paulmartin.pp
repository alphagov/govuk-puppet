# Creates the paulmartin user
class users::paulmartin {
  govuk_user { 'paulmartin':
    fullname => 'Paul Martin',
    email    => 'paul.martin@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmRLg0w+h+v/7e69My1MKdwFtwophFObBunFAeDBxz2Q06WeVPjUxjxuDSIBOD/VyRJFzN6ouxvTr+E+4pR4hk899RCfWnBzM+jWf37TZYMZ7uuA7/i3xVkad5o0gIFrvv+gdRSa5Xu2sMGt8HEgj7KONH13NXwJiKiE916Vp0ZDmVIE1qbaqlT5NA4D+WNMzgtXfekHpECnY/MLwIxdsLpOr2adsCRSR9zm6v8ycQzSTmQdrwrz28B3Cmk9E9JqVuucSq+Gnoi/Zk+nSrc3raS4PPwIXd/0wsl+d8CD7HuuwmVTE/27imjTaY0Rln8V6I/FM+6hdfBExapRCkrAd9KWC/BW10YjGjmuudqemW1khwgr75k1D3387r5nru4KJYsqb/TYbdp+M7uu7rImBnvSK52eNNyatXmgK86/pFJOJwJyPi+7XMn3EqY5wquOucsWI7RDANfMJhf/AFZzP8e6Yc/XxBdlri6ua3qCw9vA/TTi0h18O6FMz1s2nKP4+65+vjihuOJO+kl7eloIGHVEG8qW6/CBxefTKVAVxbjW2hJFlGkcb3D2g1kbQTNolG22dxRJzfDwZmsuS7vLnvlqdVEspmVczNBUod4lN59XnGa1fNECn5rlLPzhNtK0yZvtpZCMGwB/rWPADhgxXNna2CLwC2Y7C7ejcp2QSzEw==',
  }
}
