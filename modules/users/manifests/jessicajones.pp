# Creates the jessicajones user
class users::jessicajones {
  govuk_user { 'jessicajones':
    fullname => 'Jessica Jones',
    email    => 'jessica.jones@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFYG8GSOvLtTO7cSrWrQ7tXOsZ5Rmn67wQfOliZMK+EAb2bFpMUNToK/IHQai+TZMb+r82TMt6ddkAHfhIOritt4KuIyhM94jVNsrAi8OqYkgktq8GLZZhiKOp+Ro3QC8H1kJYreV5WPf+ZJe4JRcDnTqSVY1bpwCGQDqZTESPaKfHANF4Mb9KwahLl+ocIk1AfOkWmhlDZRygr0cWruFDNx5H8ldRsSS9bZE1Acn5aVp3fs7Y4JtsHt83q/ru9u7dEdGu0vbRy9WAj/gaSFJ3D0GzeOpBcPnprIJShb8Z4D9adi38LinBp1MUNfhMG1j/a5A6VLOa1T/YkuRhuaaR9igjCdjOExJy4vxNAA2enXF+KuvNNhFAggCJjuVPRFLnTS4SD5JeDC7O30r24oaqTfy4TZHtRTGvCGSZ6xCKU0dIEiXTDQGu/j4MktaY1k6RBc8NGOiGQB8d0mHs2x77P1dgNJ+1fzUavvdcv4Fib6zxOfFY9crAu/muIZAuLM0MOLbO+lZbosJJ5bwl+UkXWUpMg9gMciojQ9mV7Pg/uIgOWgx94fc7tFrpiwhqUstOecscqfqzxGDLBmaEW2TOwhk/6j7w6Vl2NpfYu6LTmH9t2mBwrTyDzLpGbIA2xCGMlmR7YB46wKHblXnZlxBrjum7h+x3vrw8Wo3qrB/4bw== jessica.jones@digital.cabinet-office.gov.uk',
  }
}
