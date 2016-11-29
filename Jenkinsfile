#!/usr/bin/env groovy

REPOSITORY = 'govuk-puppet'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Bundle install") {
      sh 'bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment'
    }

    stage("puppet-librarian install") {
      sh "bundle exec rake librarian:install"
    }

    stage("Spec tests") {
      sh "bundle exec rake all_but_lint"
    }

    stage("Lint check") {
      sh "bundle exec rake lint"
    }

    stage("Push release tag") {
      echo 'Pushing tag'
      govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
    }

    // Deploy on Integration (only master)
    if (env.BRANCH_NAME == 'master'){
      stage("Deploy on Integration") {
        build job: 'integration-puppet-deploy',
        parameters: [string(name: 'TAG', value: 'release_' + env.BUILD_NUMBER)]
      }
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }

}
