# Creates the user syedali
class users::syedali {
  govuk_user { 'syedali':
    fullname => 'Syed Ali',
    email    => 'syed.ali@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnneFwJqcu1boLDf/WPP45JGZRN/VMGf+ECvGnhyQj6qz7G+iuHdm+ixUOG5FHFq3YCt7GdLbTTnjM24evVC0YlLsupt9GufSp+rB/+Z8h0Ww+8E9cD4GKpATkSda5moUPNZ4El2GWd8LnlJ7DrqQ+fIs2GN+m3mvuTiFwVJ5kYY6fnAALkXOq6OIMhS3KGxHTmRtvF4t82n3dvODV9ZkQzWze8bPrY3uD3i0rpa7wt2nrw1Kr7C5tnC2w8kXc1s0O1cVcB0RLUuXcRQLKlcdH7OiZDr1wI4j/zwQN10Q52MyXgxfVsrYWaLPXfPhlNIr/iXqxYW09YECvV67LRh0FVSDsI5BzqDbzdmqzxTRb0ZJryV8TpT6QDsLnKPAy5SpF84nEHlNKhKXehL2R3m0xBjBk4piMbPg++AtNIgLpiqOwrspKWTrND2g66G3u5qRx9mKLZCySF7rT/AYFzKdUulmLDfM8RNq2ceTVL9B7LofcAjewbxxvcmDkbDmglAv6aYtjgpKSYZTMzq6b4dxWksw3g6SmiEs/yMVx6jdpQVxad9BX7mabGwZbWHgGE1PUddhTpyuUMHLAkLPvT2JtIF03VUvQxosXJdF4lHQr0qS0enYex4zz/QfEJzj8Pe1GkyrNl+BD0QuOe7uW/sIhxKvn+iVjp+0m9T9BZO0Zuw== syed.ali@digital.cabinet-office.gov.uk',
  }
}
