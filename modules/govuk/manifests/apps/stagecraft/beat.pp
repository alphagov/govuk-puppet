# == Class: govuk::apps::stagecraft::beat
#
# beat is a worker that manages the dispatch of periodic jobs
# for Stagecraft.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::stagecraft::beat (
  $enabled = false,
) {
  if $enabled {
    include govuk::apps::stagecraft

    govuk::procfile::worker { 'stagecraft-beat':
      ensure       => 'absent',
      setenv_as    => 'stagecraft',
      process_type => 'beat',
    }
  }
}
