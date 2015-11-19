# Creates the mathildathompson user
class users::mathildathompson {
  govuk::user { 'mathildathompson':
    fullname => 'Mathilda Thompson',
    email    => 'mathilda.thompson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2FB2W0IA3w+tL25C0ibDxtVutxpiRibJUZHSCsXNhkqjiFvJquvV4VrRuT8FxTl1m2U6WLKhjd420NH99dz7emf7lijO5bLzsY6QyrTtiBtIRX0q3zjx+jcPg/nK6+hIa7yoP8760KerzSR9vaQ/H5rsB6mH0psbo9Hdm/enIHCUA+z8+4SE/Vwu6FuaDgFnRqpt1Blu0vbcA46pAUcbzmQJvTsnFMY7obTg7KfO2XVcUZ2f1DDJjQG6n9m4sAOVFivY56Cx7aEIwj7vvf9AHtBPe/gUeN7YsB0J189A7JGiPXJpDdwfSAL9w8pRLDQsbzuC14GgLQLhC2bvJw6qV/DwGx1mNq26aoJxjyGeWHXAdnv01PZaOi/fYRX3r6+i38vIEpS07GLIcA0OsWXs0lM6mU3BmcwEnwOjsbG5NWY2VRmkdy9TS9Bflg+gRQkNxMC4vdJB/yzvmCqIDDtO4yJ5bsfGEPiL1yjECXv6GtncddfPgQarnKC0Wg+sTMcw1+BYXINDf0bjCIbiD4eUiBjs8c7DYJfCkGpuYPl/YY+M+bGcsSNyRRbsjnOnccLjeFXUxOqC/qQfUlPDMHXj+vxL1kC1hfkB2uBY1WsF+D74PRnNQkaoFaQq2DGGVWKpPfok3e1zBfonlmt6ugqPCF9xgchZDm0yGI8fLNc6DcQ== mathilda.thompson@digital.cabinet-office.gov.uk'
  }
}
