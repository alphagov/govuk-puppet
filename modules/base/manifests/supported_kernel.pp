# This class will ensure that the machine is using a kernel which is currently
# supported upstream. It assumes Ubuntu Precise at the moment, but could be
# extended if we upgrade to Trusty
class base::supported_kernel (
  $enabled = false,
) {
  # Required for hwe-support-status tool
  ensure_packages(['update-manager-core'])

  # Always install the NRPE config, even if we don't check it
  @icinga::plugin { 'check_supported_kernel':
    source => 'puppet:///modules/base/check_supported_kernel.py',
  }
  @icinga::nrpe_config { 'check_supported_kernel':
    source => 'puppet:///modules/base/check_supported_kernel.cfg',
  }

  case $::lsbdistcodename {
    'precise': {
        $latest_lts_supported = 'trusty'
    }
    default: {
        $latest_lts_supported = 'none'
    }
  }
  if ($enabled) {
      if ($latest_lts_supported != 'none') {
        ensure_packages([
                "linux-generic-lts-${latest_lts_supported}",
                "linux-image-generic-lts-${latest_lts_supported}"
            ])
        @@icinga::check { "check_supported_kernel_${::hostname}":
            check_command       => 'check_nrpe_1arg!check_supported_kernel',
            service_description => 'running a supported kernel',
            host_name           => $::fqdn,
            notes_url           => 'https://wiki.ubuntu.com/1204_HWE_EOL',
        }
      }
  }
}
