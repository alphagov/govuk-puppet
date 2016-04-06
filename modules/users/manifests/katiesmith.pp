# Creates katiesmith user
class users::katiesmith {
  govuk_user { 'katiesmith':
    fullname => 'Katie Smith',
    email    => 'katie.smith@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCotjZxu8SOjkOV86EapmptLqDh6nPRbqSf/LMgzafOvGakQs0i0julzteqOvIuYBSGbAY0OwAOonUtzFT7/LX/7NDapo643WyBADVemAYHDUzJ4FxONV1/APPPj9nTH5NGxFhAQ0fUSsj+m/v+rl30oa38q+mqROv7HYVDWVCcXqVGiExuEfIceiM/zpcE1bRnBuv92TvU2wxJmG2eCD/iJRtUPjVS90FA5BxJVMYGNKqW2XgQ34JXnMT9g7Ps2ksaWI2W3UKZRS1bHrDtUf25CrN4MV8SyhX8WiNVvUD4G82bA8cZGPxE7VXuF2zrS2DnrCpDm+pyTwkFBv5m8Yhp7fc9RTjin94sj4M+nBhV9vPw2/YnVxkpwmwMsSpKGr5IykE2R9eHRLCRToiXl8ENrtQIpgmPfkhyrqhNXZEqiCp35WEvjchafST3bNWGvjHBFW2xUahE+3j/rOT73tvvi8yX+iDKQ8bpnmNTzb39K63BGqv5eu4LB+a0GwxBbouQ77okd8ZLTh4m4lrm2X3sMRd43K+vIhuYbbNx4szRU2OEByfduAEsCNckPC5iNvGmlYpoPtdQffgXssvHGus6xKKx+Mn9aw0RluEzUXvCo/ae0raI98RPOoPLCjF4gmzZ2bRGJGAoeWxa7rAFKCEGjEwIl7Hl+1quNa/m5EDS7Q== katie.smith@digital.cabinet-office.gov.uk
',
  }
}
