# Creates the timothymower user
class users::timothymower {
  govuk::user { 'timothymower':
    fullname => 'Timothy Mower',
    email    => 'timothy.mower@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC68Rs4mjD6gBEx3UbXbCy4zNhYCGkvQ7fJDgP4/DDVylj99DFh33i1rjDYylW964B1dZ1obTPVE0gPxlCxZcEEKdUyUz11CVi43O/ybC+WeetGI0CdLzv543XzyBWfpZgAt9XJvRlrrgyoSwUP2Y2KLC2z7nskqhaVJPNiATY+Sn5IR/YZ2puarH4DxOsIxypwlZmIXuNAa9rII8d77mgAxCIX43zGyODwDGnuN5S2p/8gTnujE/glSmaeAQ49YPU/anWXcnSZrx+KeT7pIvfWlZfqDjTBlzJ+Qh0ac/FiVgQgrmXdLUL8mxhkAcjNXAx726yertsWQpDqcdi47T4R',
  }
}
