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
    sshagent(['govuk-ci-ssh-key']) {
      sh("git tag -a ${tag} -m 'Jenkinsfile tagging with ${tag}'")
      sh("git push git@github.com:alphagov/${repository}.git ${tag}")
    }
  } else {
    echo "No tagging on branch"
  }

}

/**
 * Method to deploy an application on the Integration environment
 *
 * @param repository Github repository
 * @param branch Branch name
 * @param tag Tag to deploy
 * @param deployTask Deploy task (deploy, deploy:migrations or deploy:setup)
 */
def deployIntegration(String repository, String branch, String tag, String deployTask) {

  if (branch == 'master'){
    // Deploy on Integration
    stage("Deploy on Integration") {
      build job: 'integration-app-deploy', parameters: [string(name: 'TARGET_APPLICATION', value: repository), string(name: 'TAG', value: tag), string(name: 'DEPLOY_TASK', value: deployTask)]
    }
  }

}

return this;
