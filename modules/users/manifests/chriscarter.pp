# Creates the chriscarter user
class users::chriscarter {
  govuk_user { 'chriscarter':
    fullname => 'Chris Carter',
    email    => 'chris.carter@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhBZy9Pg2C2/EU18xGBQkngXCAEgzSyu3ChngBvBIiiUMK0uA0+Eb/xic9LyDMh0ABX5YlB60IPb8rcFd22HqexypirBQ+cGVF8nwMaOTZko7nQTQAd8vXI/7k5fwndcXWV1Bapd15NJyDmRyH9x5F4Y0sj76jCcbspxb1gKiT624+sBvDnZDNpiiRx4TrKTOzmH9xUMonOcH7dXdG5yT7AYo5JujTW+VHvMLE62zFBNEYnbzT9A3SoXiedyHbI8po+ws7MSYwJNm2zJIl1wSg515NYHTAvsD5uRaNrjBFtgAuztXmeOONykXch8ZvnSvMzKZGjNjct3eDd2E4ua8NNiuR4sS7hccOSN+DkzktWtwMYACf3FQocG6XIbrpRrttcBqRs8rdABfT/ThgYr8m5IYdgqZuNvMjKmF95ycOJktFagREzKxOcc8RLNVwZ/920EOOjttbK3CPNwjciNbe1N6uZ9bjMD12FMZj8s081EgWyBSKjfb5Say3TMMEZKMm0xw0NDmbkZRqCNE3delPwNj9pJxVVo+6+QjDvphc1fSgJ39XDLum2UvdIIJAqEja1kacEI6p3O/3xLpZ5nUaLGnE7yg6C8XmhHFgI1DyFTcO/EXhoLY0gkeu5DnHDskSQ94444Y52sULWxHOrCRHMroIgyeEWhutyMYVwFUO4Q== chris.carter@digital.cabinet-office.gov.uk',
  }
}

