class govuk::apps::backdrop_write (
  $port = 3039,
  $vhost_protected
) {
	govuk::app { 'write.backdrop':
		app_type        => 'procfile',
		port            => $port,
		vhost_protected => $vhost_protected
	}
}