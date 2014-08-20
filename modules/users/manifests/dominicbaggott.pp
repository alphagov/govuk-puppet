# Creates the dominicbaggott user
class users::dominicbaggott {
  govuk::user { 'dominicbaggott':
    fullname => 'Dominic Baggott',
    email    => 'dominic.baggott@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-dss AAAAB3NzaC1kc3MAAACBAN2k/vmbaC/f/zbcblgCV1e2JpRtKb+qGtqX/X6S9ZjtU4YCeS8R4C7W4Z399hxnNfQxq3XdfPbaMWvnJC7cw/YgsP80BgC4MJqPG8O+WOC/DyOu3Dd/hlHd84RjJXBrz2hHSrVS/qJ5vTlEMCk6mNuFGW7bDt6rlK3gHm7azf+VAAAAFQCyxNGs7Hu/CmEsBJatxZ/xHizYrQAAAIA+fvyKtJP/JZbuIbeCF3oFAV6BX66Am6/J6cD/c+7LhtUIbvV7YMoHcAxp81OV8ux0BM9upBaDsquCmDjAuG6gghOo5UmlWIGVsR35fAK/VRRTJopjUQNa4Q6TT12HCL6B+ijfrBzp5ISe5I3rsPdEVE4Nfk91MacFxGW55PhnegAAAIA1HLrpZ4GI8cte1JjKARDkkzL7/2ZctsZ0rAk9t2iZgP3nUY9qes6YobPNnIUXxt5Tw5DvIxbB9LC+6PcOmtGJiZSGq9GOdlQQS8EmBmqxaumaJRr8DwwrgtLmqpcetKobzd2bQo5RP2Bnd86m9uCdD/3c0fVuegUhaurUn4yK2Q== dom@thor',
  }
}
