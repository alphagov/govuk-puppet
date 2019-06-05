# Creates the stevelaing user
class users::stevelaing {
  govuk_user { 'stevelaing':
    ensure   => absent,
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1gVqgpzk0hswuVTlB6ICy7ee66ZpXKdDJubLrZ2+k129swujlwBTPmf+asS/2aSRXhC+rrDTflYaupQiGzuZZkO9sMzKoGVr9EyHZcjUZU7jWj66rGiBi1XaF3I1ZdiJjVRdrJ1jMcAnkkPeE4jA2LMuoO5h/Xlk5tiu3h3Wm6fa8QBvvpIf6MtqisRlsNqLUIt3+7K+MCO9ZgSdb8VTO8UKlfk6G0Lby5ptKFu2yhlujeJD3vCcO41XRuzLV3Pb/rRZPPJ8LNv5D+qV+TO+s1qJj6xrNH5kn48XveebSglu/YZWG0NYnDvbH7dKyKfKenJm/UGY/AYR3ZoCkQxx1eZlEkZGRv+U8BT4gIKmdc3VQYC30AMUF/trNDrWAJIKJ7f8XiT9Zc4NGRBSJ8OH+RWzJ7Q4prW1MxViN7qOmpgYdHTfnPYndR+j4n/3qkPO4+3R1rAPDxNReoMa30mUBWyKxkifp16CmY+kk6UdrYs1lnPbDL95EHpMlDAobKoRWXHIWA+J0luhZ0RcHbJA+n8u8bJgUw3KaFKerdjzy6dxGEMVTzkgACA4f9eePtwBVMTv+vZJZGOk5V96VrrMdhzMX7xmNW0twkRyxy7SOd9fUGqGqKAEC396d67HeH7IhJuq22rRC5CNWxJpITFPpVdMjWnYEYqYQcBl2d+9JTw==',
  }
}
