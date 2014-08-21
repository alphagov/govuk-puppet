# This class will ensure that the machine is using a kernel which is currently
# supported upstream. It assumes Ubuntu Precise at the moment, but could be
# extended if we upgrade to Trusty
class base::supported_kernel (
  $enabled = false,
) {
  # Required for hwe-support-status tool
  ensure_packages(['update-manager-core'])
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
      }
  }
}
