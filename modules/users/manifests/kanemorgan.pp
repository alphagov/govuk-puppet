# Creates the kane user
class users::kanemorgan {
  govuk_user { 'kanemorgan':
    fullname => 'Kane Morgan',
    email    => 'kane.morgan@digital.cabinet-office.gov.uk',
    ssh_key  =>
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCD0LoZp2zKmABCPPDaIWYccMVShuZm2uUKuHgFOH0BmcZLpltSyurefTRsIQqog/nj8tlRe2WTeHB3qPJNcdMOisWhei3W848QgeF9jZTnjagVi0TJ3YcnhOJUTC1l7x9vVbMB+eOfY5I3l52HoYqwX6U6+GQ2uX7cRn3oEKmqXbI5nLtdyKHBpFvbQwTChLudmhdw906AY73yUdZGjB6fdQ28woTTRNOWB+Qaq5A+Lu0yc9Gy4ovJnzSDBi/MF3p40ru/MdPVb3/mhaA9v2VjDP5GdrP3GjEezW3t4jq1qSlKSRLw4R8RbuvbzFRlJyiPxgpbaalOXp9Rv6boQldoA+n2cKyuQCmbPbkGG2YodlvczeWy8BS0qp5Ju7J3UF6weDv/deOASJlC+xQvq14TsfrrMwrD8g9HiKNJkiX5JqBcp3IEixz+sberriV4M8k/GOE2UNoAr5n1PrDn9m6MUFjE1ZNOJr2QUuQA8EmxucXfwaBVrd+vfSYZ59/nWJWBXQVthlxu9ICIUCP1pH2TDApo8WXCfB6X6g9C7NqM1PHz+FMGmDb6pMHSDIk36WMsxTkJDrcqxBSYVT0/n1K94B+zGVQWB5ZIM3JVXmii/bf7GWB/N8JMiAYjkcfpVlGE5BHrbbz/wtVKApqg8JXe8ziWkaKJ3jnZNeX+9Kmzw== kane.morgan@MD001',
  }
}
