#!/usr/bin/env groovy

/*
 * Common functions for GOVUK Jenkinsfiles
 */

/**
 * Push tags to Github repository
 *
 * @param repository Github repository
 * @param branch Branch name
 * @param tag Tag name
 */
def pushTag(String repository, String branch, String tag) {

  if (branch == 'master'){
    echo "Tagging alphagov/${repository} master branch -> ${tag}"
    // Uncomment to enable
//    sshagent(['govuk-ci-ssh-key']) {
//      sh("git tag -a ${tag} -m 'Jenkinsfile tagging with ${tag}'")
//      sh("git push git@github.com:alphagov/${repository}.git ${tag}")
//    }
  } else {
    echo "No tagging on branch"
  }

}

return this;
