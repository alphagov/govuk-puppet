# Creates the davidsingleton user
class users::davidsingleton {
  govuk_user { 'davidsingleton':
    fullname => 'David Singleton',
    email    => 'david.singleton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT7A4xuyVp7s2aZA68boarLAn4p3+UIvQmu/Kfq7EP6JZsrnOip2+Xd2ztRkQ2mwG9AnrlMpugDfeqBzbdcxE3H+rQPFGlWen8S/5DNl0eB6ElevQ9Kv7sMGCidmIsfQGz5wi0TxyREv33Ge2iR6auoXujYzCX7eP4b7R/ieEd0Okhd8Suo6cYEwbP+UJVJCpwxSzNOce1L5FST9JG2a/QJHxw6siM7AGkSwze3SY8lN2o1Vb4WC2pdcZnBE6LwDEFQdqdWUIO5wZByoENda+GyCLb19A6tt7nhED70YtwUimpXeMS7VIkywDma0xlE2Lt+0pEQbPy5UrFxw/1Gyp83fjCof5J9FGRQWQvSjhQ07YZJTuZzYdaFf0ZEpyAhpNwNw1wp0Qckj88kD12wxssyIrzic1Q93YiJ5q/8K+bGy0+VQBSCGJOtTKKpT77WaZA8iMsgDwTct2IsHXEervkQnZqeVrS+zy9oWyHG+6Ef9UIzRw4Sl0a/mqNqnseSzpZFn7ivUdXy1gin3ZzchwMyLNHEmXdiWUQwEHw/QTlzBIzv5bJiUuH+2ipdep6GB1aVgcEINCe3hMfaEcc2LK03vOkqCJzNsMStKfUAn3SjkyCxdnCpO4DKy7NyZBvjZ9fN4a2OEekQLhWNqwa4ru6IRzQJyICZ20c2MV8pJ6AeQ== david.singleton@digital.cabinet-office.gov.uk',
  }
}
