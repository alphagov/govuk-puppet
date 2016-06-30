# Creates the carolinegreen user
class users::carolinegreen {
  govuk_user { 'carolinegreen':
    fullname => 'Caroline Green',
    email    => 'caroline.green@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFUC1XR5VXWfzy/lt2gxXYjBIwgFRd1XZxQxvJsywN8jjKjDngubfVTW+fQS93kXK/fdj89/0Jxkl7BbJ2t3E4QY0em4dcyXwy3at2Cd0VjzluTMnRYbgInX+c2g9JGSWMz6gczN+6p5flSSjgTOT2USRsBrmZunq0RVabQTmDhDr/LWaoFUHVvqwOKuh1HdgYYmDduuhi5tjka+eQmSvw9ptP5LO+WEPuy/V4KdQYrI6EKxhKE3A/jQnv7Q9x9LrUC/a6pWAf2bcXEDHHuP8iHT8SG6lBHFlNcc9jEL1DaKje0WQ3i4uMi5b7BlYtaXx92LqNE5kWdTnTmAsECMVHxboDxSxtSw5tICpTiw6Y6rltZx5WxqW31aau/l15JNg2yjuknxqBap4EHuBJkZM8LSMehQcH8pte1N6rQ/QTkW41+QnWYPw3VxBp11C8mnaB+d1HyX9h5gwbFkm0mi4UV4OQr4HjAseRbLIqsOTI1Vj2+gzuzetR1QcyM3IW1sJ2WMnS7QBacJmJ3/LTVBLytXCohnZENNxHjHjUcnqD0Vf2ipII2x2jJF1/L8IoYDCxEEZZMPczjW8+SKfODoDott+nNDmL8o5+kpJVXkCNKwRprjQhllfmJIqctLm1vZe+sUa54e4aSlSQNvlgZpJ+CeVxX0tQe6Ep/lPPsjeBUQ== caroline.green@digital.cabinet-office.gov.uk',
  }
}
