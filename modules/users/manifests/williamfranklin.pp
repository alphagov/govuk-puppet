# Creates the williamfranklin user
class users::williamfranklin { govuk_user { 'williamfranklin':
    ensure   => absent,
    fullname => 'William Franklin',
    email    => 'william.franklin@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3uh380Iw9imWxUOIpJGAq6VQZp/XGRI/G5OdKF9J11CVImEPo6STMGAnApXF559Bs12Heu7qVSbffDcuVcbZqB1AsQUqPoVK61exk9ORqXJ1GRZjsYU67Xpb+DoyEX05wgvWO26baYKH6l4e0DOVZFUUpMWJ5Md3YRogNY3nvobnRtzyifQWiY8VD3ECxCPyionOMnN0paZCxEGEPH5ALMGlycz3YjjBvIe7WC3oBISzOVDhVgBMH7cFT4CNRzj9NyU7zEEBhBy9Z7sOXVuWG7gi3S0zIgfjNtO8cMRGDDIo+Dd6Xnp0+Jw/ZwavUC3YLVu9L1niOIEKMLjFS5thsK2UfrYYeADFVgl9UyvYyDaLEpP9lXDSfSu9/xWyajnXaCCS1ZpOGGEqVhKklPKCJ83EpLHLFYW+yO0W9shPGXtpT/zVgN2A48u/TmqCaCPs17gX8Iaam8g9YYvIqSZ8ZuugSOwkmdm3EvQgcs8qiYyJHzyo5XEv2JO5whBS3QaieF5adX6mlh5I4BMGq4bV3ua5Stoyk4cPwqTtcNYM/YRmlobRNvNsslRH1Kz/ioEFBC1oA1qa4slkfHctRo8bFDh/WFLdwQUuZxEUGhcE3hLUhcrkxVMaEP0NLkuDsweDnUgT6gW5DBwXkeNwamSrf4btUKvasp4ctjOOvzcoWXQ== william.franklin@digital.cabinet-office.gov.uk',
  }
}
