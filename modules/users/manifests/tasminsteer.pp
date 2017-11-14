# Creates the tasminsteer user
class users::tasminsteer {
    govuk_user { 'tasminsteer':
    fullname => 'Tasmin Steer',
    email    => 'tasmin.steer@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQ61Mn7WsLYoQbLWHK0n+fyfdaHNZ1FnT8FhMHAkfMyVmP4l3li9d1FHNqPa/ozgQVsMMxdshosdscG0whj0jC3hUwuDseekoSSCk8dgbNVjbk1wEEsMsFOhDg+QspWGQotew6AZovk1gTxThhrwPsYbhe0jPzbgIVRErsI9MEgbdiBm7uUApCyxSLX8drPUOwR03SHWzNwBEpeJar2KrW8tL7LD//hXvOYLPHf3bePV1bl1cwKUQF80IAnm4A63IPkO6rqz1rkTMIvK6w+Mev2OTkJtkwWb6pFFzIUUFAagQSpt08sUK1MUKVfFJ67LsF7I71EZ0soJ10gjZX9A1Ut85H4OUlI0U2riaDHG26yRJLo1Y9A5kXAQ4xr2Vtk8lNikJIGr0svZkYcI0d8VIgVGabdofQl0iSTWFnfaUMnjp/JWIxP8armguWbveLHEVm/3A+uHNETL3cTbIM22wOJtXM/3QKNkbyoy/jIKI/s+1JlWoJtmcjFcHLb5+GvE2TA+Xikzrsx5pRxP/EpG7zhXL6eSyuWK8ET7JPP5o3qfsHVr5h/K3YDSKXiZXznP3up6+Sz36/vbfgVLV2jqzqdSV0tAhBVZgQdTrG9kLSUdKwGVr/qouKEjyylicMkXBnXyMzuwdArkgMRPrJihos5wYWYpJSYnitWwCIx027Bw== tasmin.steer@digital.cabinet-office.gov.uk',
  }
}
