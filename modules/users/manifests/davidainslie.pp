# Creates the davidainslie user
class users::davidainslie {
  govuk::user { 'davidainslie':
    fullname => 'David Ainslie',
    email    => 'david.ainslie@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAeI2wU/gbLl/PplWY02EpgcwZjboRaaB0/TDu3Rwdj6NKlRHqHkHWkI0fcOlhq3XIV5d8tlAqsCXy1X5nJ1zYxOEx6S3C7PGJOus2AxmcDmZGi9MmVz/pTNsKahz7/v++CZkoZYBn/WgTce3Vhz2L26y7jzdNi7w/TpUJInIwBl7FDTu1hI0cUaQFix81xv90QwK4f+KxziqZpIeu3SXAVxuAwmniN11qdTgNeSnXlxpMVbfZmKfbX4mbnErl24OLww1gB9mY+QmXMzsYEMqEl98VnmR1evkhawN7oZQLEkEu0FsUjfIjlIK23NJJZjNNcFVQ2YtlUK72gFYRz769 david.ainslie@digital.cabinet-office.gov.uk',
  }
}