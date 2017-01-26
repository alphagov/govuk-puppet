# Creates the dazahern user
class users::dazahern {
  govuk_user { 'dazahern':
    fullname => 'Daz Ahern',
    email    => 'daz.ahern@digital.cabinet-office.gov.uk',
    ssh_key  => [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxbBUEvwk42dKZgtQPNLhKj7BahGfhRt8l+uR5c/xCWR8mJCmYcQ/l9BcejGEekQvfZJC/D0aUW1ha2E6jN3ZK8YlW8CyNN80g/lEfmICWVY+Q4seSP0Vamk/x+ZP2fqrQctyt0cNOeutrp40NxxGwUUD/FP3qf4rQAOq61v2Id7tZaJQ0XqgjbHu37fFuw0Zc8Y00cfDunbXZz9ZUMBk5oy0a78EoxbX3QavMnsixa6gJ/DnXR71ny00AIUjKUCBIj7Sb3abGmYg+jv1HDHNZXZeg+SGvxkQ5jqTK5OU4Yk9ahfeNE50X1UFxpq2VIywuKLfrZcUhaJqSiPxReaMU0Tib/iQ/a8cGPkrudS+arasKjvbnqCmJwr7NMZWeckpXz76SU+mURzgcLLBtQkceix5Hn6XL82WcL5zSTsUcCBmtifXnQqmKzGsK9iXdyxFn2pf5Z5E89jaej7RfMUavPGOh8w/EiOyNvLifi0UEMrPAvmtj14CriOPBCVsCyacuT7vGmMBczr9b3DSyJDqfgdFnpGlZzt6FDnpr8E4RpKoYuqFWIkgHFMDPhYdy/+lh1ul7iaKbGHfNSLxOXzowsF/P+U8dPSaRlGSZT6xTKjq4eawOqWSlOTjdBje42A8Xn3MwMoDJwxdKJG+gYFHTy/zmbEF+k4Z47A7tE+CqwQ== daz.ahern@digital.cabinet-office.gov.uk',
    ],
  }
}
