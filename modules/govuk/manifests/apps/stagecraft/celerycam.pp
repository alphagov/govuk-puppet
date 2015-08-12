# == Class: govuk::apps::stagecraft::celerycam
#
# celerycam is a worker that records information about the job queue
# attached to stagecraft and stores it in the database
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::stagecraft::celerycam (
  $enabled = false,
) {
  if $enabled {
    include govuk::apps::stagecraft

    govuk::procfile::worker { 'stagecraft-celerycam':
      setenv_as    => 'stagecraft',
      process_type => 'celerycam',
    }
  }
}
