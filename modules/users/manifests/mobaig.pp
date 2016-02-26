# Creates the mobaig user
class users::mobaig {
  govuk_user { 'mobaig':
    fullname => 'Mo Baig',
    email    => 'mo.baig@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9+UcAnAsFO5yrTC+kKwl3XGVJq/tRedPwir4i1D0uTgNKpd5zx1YXWCAMw4tWng+euIL7RlK0KFP0fGJelBscUViO8sv6ikY2CiXTEdhGIamKp7IBMDqFFlExuD1PoeVhf9tJU1NBaiPqXj3t1t2BX5DL0oQ8FUwlBHkZMyNQ4Brzke4cnj2fjYkWvDnslrvlCu7+TwmpnUyv5eDy3Aoj3cAIFkf9YvqNHE7G+eA0ZzDUwr3b6jkUXCUMkkq4WioKbJwNyxRfqlXFYZLQVoVMfYUAfruRpKdFJnKSSKxlDrlfLWvZE7uPi2pJSGFPV7iBbw0sbpdnTQG5060NMmxBBEHIgdWqsryo3vFkiC2of7+Hoe5z41N/VJTVLl4lrQ1oOmnopm9vGKHeO1PL7UAJabmlStoFcn9QWOaH+OEfdezjI5qZwmrKubhScPLl8fAE5mCbTjuQk+tsTxak6XdsmAUDX5Df906CdCq39IE6aAybMQr/mYQGHeawL/AnCPHzK6eUW23eSalbNmt/11IH2m9cTOpCMzbYzN+GvXiYCYfX2M7qj6dof+8U5hY7Dbng5EKXBdS7vPZ0DK/dqJKFGYqxdWLvNh6pYK2pQqmwnlyEx2dWLMqBnBxrHFNoppPery4NJkLJusX5B9/6VQf5V/50QMEBR+CyBGz+4bhfMQ== mo@mobaig.com',
  }
}
