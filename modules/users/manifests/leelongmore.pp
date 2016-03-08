# Creates the leelongmore user
class users::leelongmore {
  govuk_user { 'leelongmore':
    fullname => 'Lee Longmore',
    email    => 'lee.longmore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeCUymVRHNMA/wEtDGG2s3MMRbKqZOAe70yXTsFNlvsdlnyldqpQq+mJ+MRClRhKuKu+/OKRgPIpO1/uq/XtLS/a8XCK46yIPOkZS0kPF1RIzVl83S9/iYEAVbSh7y+PRrBDT7UI53oH8YCNaF5Z3WeFc/XMarTb6O71ig/QwFmViIPvbC2gEGRNmmygsDTTjR1ttipOBObbqZlj99jTTx0kpLPQIqSNrsEm7qTf3Xip4EZQtzxIsxKdlyaQw6IgC8jy6spmkbV8jU5qD/TpRylTdYS4IpUyux6kWoYJN/uCeYuL0wQjLjvGxlCLAbkUr1626X+LmIAQ6RWnWnnGHBKPm9KIHX4j18cMOpQO7rwfW/UHKu65QKylAWmd1e6dExoSB0VSX2/YVFu+j7/k6+j0HOPfeor0TIgpoNeZXFPjo3DttRIktNF8I9svjpSjqgsJBsWreiOKF5si3amFNXT52ibzGBcu8SEPLAKouG9gP3s3RDZG+te2r+vWuRHpmtJnPyLrjBzLHWQX5Ku+25eYH5fEul0R2QGEIfMec06M6EE1thi/at1J2eLNcrNtLNI5HIUYoL9kZc2MH/nAIAGX9Ejrn2//np+N7yuSBsnzLFMuZuQBE4FM+fiRPXMjqyCRoFWJKNU8e8jMv2felqblQtS1u2urFlD2Lisy5/SQ== lee@turkeyred.co.uk',
  }
}
