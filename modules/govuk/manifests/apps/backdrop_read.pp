class govuk::apps::backdrop_read (
  $port = 3038,
  $vhost_protected
) {
  govuk::app { 'read.backdrop':
    app_type        => 'procfile',
    port            => $port,
    vhost_protected => $vhost_protected
  }
}