# == Class: assets
#
# Ensures a machine is running the correct HWE kernel
#
# === Parameters
#
# [*enabled*]
#   Controls whether the correct HWE kernel package is installed
#   and monitored or not.
#   Default: false
#
# [*check_enabled*]
#   Controls whether the kernel version alert is enabled or not.
#   Default: false
#
class base::supported_kernel (
  $enabled = false,
  $check_enabled = false,
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
    'trusty': {
        $latest_lts_supported = 'xenial'
    }
    default: {
        $latest_lts_supported = 'none'
    }
  }
  if ($enabled) {
    if ($latest_lts_supported != 'none') {
      ensure_packages([
              "linux-generic-lts-${latest_lts_supported}",
              "linux-image-generic-lts-${latest_lts_supported}",
          ])

      if ($check_enabled) {
        @@icinga::check { "check_supported_kernel_${::hostname}":
            check_command       => 'check_nrpe_1arg!check_supported_kernel.cfg',
            service_description => 'machine is not running a supported kernel',
            host_name           => $::fqdn,
            notes_url           => 'https://wiki.ubuntu.com/1404_HWE_EOL',
        }
      }
    }
  }
}
