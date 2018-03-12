# Creates the jakubnaliwajek user
class users::jakubnaliwajek {
  govuk_user { 'jakubnaliwajek':
    ensure   => 'absent',
    fullname => 'Jakub Naliwajek',
    email    => 'jakub.naliwajek@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhv1qqcJFT1OOH4malri+fwVXlsAk0sPAZ9ZTTmcvGNhOb9eM8eizILa4vt9OteQiIMUzyJv7QnLhNalbrrrsAkMdmXmbxLXVdc/skFuXNmlwdUtUJBWsQpRQaGT+3nZFGGW89l2Q+mSSkx7AVEgWOs+qrkH1MBcAaD27pBbz2hpFuqAfzHMgi/tzBJqac4TZshlcNzAVfY4PhGA5WLtoLTrcTU+N24HOf0Hcc8J1i+xhTVVEGpjuMR3FikFhKSKjbcRXDoUS+EcdAXmjy90wzhnLOQ/wnJqqQ23jZs5B+PGYF1Jt8mQMdxehngizO6VMcu+C5W+tSvw85Q6coYWmC9YUKekI1KCQu3oD2CNjiDoBAn9JU+KkzDFLDxwwp/cLepUKPvah32k68yuh2G2u3JY5dVt0wrNoGyowrJ33jwIp6oiVK8XV8r+EgKA74FDCjeAIxd0ME5cohmOYCboEX3dxDPCIQs1qzNKdbrK7sZzB//jTD3WQ/5y3I8qNEz5TFQQyT7gilZvbrlbg1Rid6M++S6jGTV3mri+1k9tDK+M6skO8XeVOaFcLR7xed16K2EJjOzcr5BiXNRhNplw/E+A5OzEeieu0pUVywRGhMVR8IXK5c8sWrc61rbvfAKEaoCLxj4adYRNeAEnvCUU4EmuEkMr9HNf1IasiuXiBcPQ== jakub.naliwajek@digital.cabinet-office.gov.uk',
  }
}
