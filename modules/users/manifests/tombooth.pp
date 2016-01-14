# Creates the tombooth user
class users::tombooth {
  govuk::user { 'tombooth':
    fullname => 'Tom Booth',
    email    => 'tom.booth@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXsr6ArkA8+cJaTBUnsdUmWbXevETDpJjwkIpG0QK7HsvVNZrTUbBqCnkq3S9RGmqwDEDomV6lwl6mcT7jfnX4t156l+lPGb6Bc3NLLLvzp5ezTM/HuCbsWrmppZeBV4u1rEOPB3mW97P1lm548LUVeb0lQmsR14VmHVHbTk+kQNRWn1Qw9eRAcoYfJZVFl3B2Gz4S/ASMm7ZkIRnaTmcZg4Pqu8n9fOpQLBF3bql1TZ/EWuQzt3FD2cFf/LsolxSd8Q7USsROkRCb9JnUAovxlMd5ac83aMgURVswzxq1CM6E042XmOMswjCZI1/ZRx2jJogH1UMeueXguZxvjYBbD3ixomtLW+4fsWCXg2dLgzZmGZAZIP619Gkqg2pCKDXRYpx0j2TmscJ53dUf9v1NU5vDThz4yCRN1o071ZSd4uBwonPvHINK3yOHOY7EnM/HjQnQQAFhdZiXKSJiOUM14bRH8vCsMYxr9ZJH3EDAR3U0Kra/uCnVjNGo5E7QS9BO+BOx8UBjE+RBOPNLSDvh1oDtnXNHULBntlXcJimtub/Z77ljnMDU8nPlacvKgCZFdsr5vxvIsvz0HT4U5ccSKABQNHkSdPYmOT0yCWolpHbIhjlt49NiFTCNqka951J9ygR9Tw4ptBOSNVEKp52iY2Y5qvxMjGx0uKZkXPcNyQ== tom.booth@digital.cabinet-office.gov.uk',
  }
}
