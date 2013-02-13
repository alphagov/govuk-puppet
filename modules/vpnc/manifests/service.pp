class vpnc::service(
  $state
) {
  service {'vpnc':
    ensure  => $state,
  }
}
