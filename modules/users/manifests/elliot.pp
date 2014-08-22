# Creates the elliot user
class users::elliot {
  govuk::user { 'elliot':
    fullname => 'Elliot Crosby-McCullough',
    email    => 'elliot.crosby-mccullough@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAokaPnUpOiRSoekAPu0ZY6JnthFxVeyAfnlWGcZOQ6PhnbJ8vIz5jIWE9BdLbuTq4DAr0FGg0i+9EVLyXwphvzXJxPhNFQrRnT5gbyLgRPTlArnmT/F1tBDAYEbS/Dj3cL3k3+5THcqQ0LhrNXgfz8+hdLVsrWW7gCD6soMxLk/Jg5AbF0e9drA+uvfhehSzUeYYPEesIOXp/+OVyKuYq/n7UFSqym5j2+Rg+eVPRoyzFz4SwBecXqNq6r/Xf7oJeKD09QGAPr2JNnfB3trFg9yj0c37EnrHE//slk3DQBlwdOZmanK+PbGlxH7/hFtg63bqo0AXfMC/e2ElvFJozCQ== elliot.cm@gmail.com',
  }
}
