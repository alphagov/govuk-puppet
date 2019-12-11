# Create the benthorner user
class users::benthorner {
  govuk_user { 'benthorner':
    ensure   => present,
    fullname => 'Ben Thorner',
    email    => 'ben.thorner@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc3nA+A2sdRtTASBD1uZ7koOCx25eZvG5muL8Q9ATV9ajiZiHhtRLrlfrULWtOwhdEuZe4jZpN5lQRmSkX8V8zW1hrLoWEod58JwgJk6krTCqROp6AMzgCpcqExMKU/1zab+JSA7KYcdC3TqFe8rjbF63L6OZaADZra0FI8jphCtbVzdZosEWD/VQw7PISjNu5FR47OeAb+BFeB1hPqW81cm/uhbvV00o2aQe0zLf39ZMgpXhQpfxIJ4yNlRlr/JcRKtw6cAQnnGN314WLkV01Xg4Q2qWYIdEtwf53ua5uic3Z/KkB/QwgzluVJzc6VoBLxoPp1RExKfgS1OKe2dq3A6pTjAuJSgAuateFuhfB+Eaxc6QUulM8NtFfMZ1imXkK9Zmy955dKXX8cbMcu6mOnwVxtx+sD+KZ1D2aLKtCRKoOk0HbE9J+GWPkda0vFhQh8mm67ZCf/lhLFVCpZeGp6AH0I9c/soSIewVggJRiLUtWXDUT00Nxy1bqCKvHjEhL5OHRhGSIX34cuuAzylWe5pEPIJ4mGSMCGZErWu34eTCAq/8Az6Q/7Wrwqk37m/aoysI1h90/6TwLtEiU9/kCHNh5DEGlF72hIlzfggnSeR4ND+mz/6cbEK0oOkR+rk3iJCforgkxfb66Qbgak3PijrERa/FhLLDYGLLC0HkBLQ== benthorner@GDS5058',
    ],
  }
}
