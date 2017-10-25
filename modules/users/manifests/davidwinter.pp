# Creates the davidwinter user
class users::davidwinter {
  govuk_user { 'davidwinter':
    fullname => 'David Winter',
    email    => 'david.winter@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6K2Mw8zMH9fgissKAmXdXC4yU7VrnSQEMgqKM2+Dk/BgtQO+9wNLCBorhib0W3X01QPSl6C3VTB865hxgOTCzfAUzEyz1CxUNDEt4mY49lFTOlt/bC8chK/uewQQFUIeO148hFmEOBAC2IitNUHrSzqy+EDVf5QNwPkTWtpsleE5x+qx7V87EajWnvBYj1bwxaU+u/kAwcg3GhSiWnHpo5hcWgn3+M2I1gJtT6BtQXeIpoFuKQkL7OT38DJylLkjsXjQCjSua9CR88saEZyaH/xL45LEuDqWbdsb8G9FyTWSMlFinuRjlSyaG0FLM10j7AWV04nuvBsXtft4wTwcNggxeRokpN5yYgnhindQNX/jrUQUqYncT+W2ct4+v8O9BQvdcambWsRhwetL6gtAcsDVEP2DVBrhhmPYXLk6pxS1hkftYY4PR1txEUr7WK6X02ICzIlXQ+P+DqmHaj4kw3ykIDmeaw/6dHOA5J3GdW6bZoaQVdYJfZca6NPVudr1SCXUp6RXs4plKeG1NsEsKHDE/5ZYdhO6LWRib+cpsgMmZ2xJOr8//7ByuIVN3j6WZINeho0pa9u7Ita7uGon1RCm/olbxarYCc89NXc8QffGG9BmrlZaIZoQYL1jS7UMJSBNdxpk5FgsOwevVg5t6cGZh9Ph+srLLyErVMtyl1w== david.winter@digital.cabinet-office.gov.uk',
  }
}
