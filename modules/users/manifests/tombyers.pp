# Creates the user tombyers
class users::tombyers {
  govuk_user { 'tombyers':
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD2O8LV4GvzvZv1FtS5CRHw1pJ6hqKHYjkyDd89TqvetMnGiArgnLCh4F1Fm09cZPADXtFoIo4h57Mcrj2EasmB6QNHpokW98nJwEFbGvjvGgAcziylgz3G2wOhW8/cZwOPjGEDHawxxZswHwVigL5LPFVcaoHJ/hXPQLXPG7E+kPY84/2Fg2dh+DqBfX3FMx+zsJ/L1LVsLPyg4E/6rZXZZcPSuQzeMrcV/sckTEnBJtGZbwBy7s7NgIkVkz1K8hX24IxWBVBfo7wu0tWdXUPdeyu8wmVbvf/XDUuoltY4qh8iHpCASnSj/JIDBsi3ThDetjV3BznOPTqa5eZrE2W+RVFgMcU3t9xSpGmaosz8t5wxN4eJSmNjhQu/Z2ANjJ44J98O6kvaB11A0jsc6lp10ZFYUPSV7axfDygmBoLptkemc7sddb6XrzQgIL5Qox7Q5ka8FXC0k3AnEfF8ED/tUcdXawcl4wXAzV34atvehktn81p3jc7fAkd2ivF50dHaxvZZjb13CazXtO3D65jlq3YuXyDb5HN/vcP/24/8bBEbMhZ1gKAPlKIJc3uWIRzjl9XmdYtLlK6UOyMZdOtFjUvAxsn5t/jbfHY7JTC1yc6LL9t6juGXwkWQlYg7g3QQ/DRW3BZSpckGfrRXebae2/YR7F86TcHqekLgJCRqOw== tom.byers@digital.cabinet-office.gov.uk',
    ],
  }
}
