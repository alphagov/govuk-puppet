# Creates the nickcolley user
class users::nickcolley {
  govuk_user { 'nickcolley':
    fullname => 'Nick Colley',
    email    => 'nick.colley@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTohPEgi7sqjLLRBimE3KwLq0c+Fz9tsSpGOMZBxeNohAElJcn693FDCL0B9KGk2rZlhD6KjVfSyOssLraSaZAZnydDyyvLlTwY2DFpq9x+qzxIfhzKBmo1LXqY8euvfXTonxXEtxXR1ZlUgOkAPQLuQm2GypWb8BEYdolGJwSNgqIJ1CNdItvHoEgDhlLDtyBzLxXhcdyvpkTi9Iph9wcWFVHW6BvGvgFPlShqYPCW1JGU4ThNQp4fM3KfspAhA3OQDhLq/wqOOIhoD9Itcq9n5Kpl2sCUNvpfR81bfWiWlm+E976nJqT2TCRid7hs6XaLFir1c+uuWBv+mhVO9XaSnvzVFtIhDJoaFGKxHZhtmLlJufX6eT8/54W96NCagApOKglBwsPrjfJYBKnYewdIL4JLvUwvMaaD6NEDQgovCFz7dO9ic1SAizzbifb1M7YxoHtG2sqt22I0WAhFvvzZAw7C4qnXy+Ordvu5RZVPdkb/fnMM/+fn8l6LFCytyFZ+6xXoQFFvF4LYrl22ywd/vLo/qVK/ERD/D4Oc93ynhllMSfhT1BfivTccot2wH74Lfc3Xf4V9SZBFLEIiWvJuJJ2PU+KLiYpixyYrTPcwRQgU2wvCSnkXo1foZxuTn/B6pXadBTJmy9Ful6DH6gj606Omu9P5Yvfa3XMQLTvsw== nick.colley@digital.cabinet-office.gov.uk',
  }
}
