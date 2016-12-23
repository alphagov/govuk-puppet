#!/usr/bin/env groovy

REPOSITORY = 'govuk-puppet'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Bundle install") {
      govuk.bundleApp()
    }

    stage("puppet-librarian install") {
      govuk.runRakeTask('librarian:install')
    }

    stage("Spec tests") {
      govuk.runRakeTask('all_but_lint')
    }

    stage("Lint check") {
      govuk.runRakeTask('lint')
    }

    stage("Push release tag") {
      govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
    }

    stage("Deploy on Integration") {
      govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release', 'deploy')
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
