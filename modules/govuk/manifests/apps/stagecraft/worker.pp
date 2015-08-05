# == Class: govuk::apps::stagecraft::worker
#
# This is a celery worker that will processes incoming jobs
# that need executing
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::stagecraft::worker (
  $enabled = false,
) {
  if $enabled {
    include govuk::apps::stagecraft

    govuk::procfile::worker { 'stagecraft-worker':
      setenv_as => 'stagecraft',
    }
  }
}
