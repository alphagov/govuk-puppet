# Creates the davidbasalla user
class users::davidbasalla {
  govuk::user { 'davidbasalla':
    fullname => 'David Basalla',
    email    => 'david.basalla@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC43U+qOQ6O7t7z+vj8vnjo2JG3a7UhJDW/DUNEJqf4hUuhgITv6Lgs9STgPEuqS4mJxBx0O1aKbDCGf+fmVy5bYna9i0jQl7ksuDDpR2HJnbbKy/hkr+4odGVnQlJni+nOTmbNNanqEknlPh43UkL+Kd2ASw1zIeBtoUR43bQ5IUvI6mP2cQKIbplilGZExBhPAeLwYrTRLgVIO9QIeuG2IK6gpMUF4irrHuwvGkXilgthdOBb67mXeov+hlB6dJmOeWcnE8YLqdKKJaQR4XAlRSTK2kKSu1vPgyTRVxQHoH4+1wqxqfe2p8VOyzkXBmyE63Gj31b6KSYWXH/11l8fzZdSXxV+Rh1UfFAPjAMfJytAIoiAzdheyDK8fklJ1weJ/KO6+HwZABJmfeSMD5Cl0XOBEVynM5kfm3/jaz224ia4LFiJY+n37NvbWfTECo+o56yDClkFNnnACkBwv92d3M2FvLvP9ndw302OdUyHnkTsQj5d1K2Xkgyz2dX3bmGC6ftS0uvSt6OLWTorj8vqMR8F8MUcovkKCDBaR78jeZrNozf26urOvZIEyoe9IGidfNDh+xjFyvedblIiz1gW5epCDBt+VP6C7+oTep9gSwskqxmMcZFkG0lfncE69WY1vna77O6pJVYmKwU3s6owjU5JJH9gOhlpKF9wWnkX1w== ',
  }
}
