# Creates the samcook user
class users::samcook {
  govuk_user { 'samcook':
    fullname => 'Sam Cook',
    email    => 'sam.cook@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvNKDMi9JGmLQztEx7L93SHAIVxlh3Q72dq28+tEq3bBsmY3uqBziuLpoq/kxW0LxEbrsMnXnqkIU+PkKejcjGKc7Yn7yl+oBXR+XWD9PExMoH/VObg/GIBXKLaqeQQBIstDjkwNixnIXunjl2BHECX5S56ADlMkeY6zmKUx3mT+jgWhH7j5tXeBhR9+3JQjuAxCMKsWu+FEEVjLxvEAGmUzD/MmLj1Jj1I9zZAmPJR7di1r7b3MHNGGQWI5nTYNO/qfOxMz6IMJgCqRT2uCrWxxwufjbN4EEt3fPYecfy+9YT6WBsOVXt8CdflbTtFRTbH4uKCADpa4tYUaWnAUiB+AASDZmDVIe82t2L6k25opnD7bcIPW1QC/xVOwVsmKByqnxbDB1mDknwoIVGuxJshcamWxg9x2iEpj0or3YG8EpjZUdZCuK3nFbeGA3cLfa6LOjKik65Q2nRnIj7COQlqPifzNis7RxwLPYvQkaws4ly1bfoMZE2PFaeBgBYp2GEcQRpa19XGI++oMbWIjxfkRUr1g00nmSD5juswWd8Np72RlfzLIK/6Un7Su8bIkRvc673QKqgUuTYrX0yBZZzvEfj+aEJiyeksnqFKXE3G8jzNtl7hAcOzhn+wR/AP4H2qqAbeOtowCm0ATFNUCj2SMxA+6ETKdQX3Gd/3aAGYQ== sam.cook@digital.cabinet-office.gov.uk',
  }
}
