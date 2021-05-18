#!/usr/bin/env groovy

REPOSITORY = 'govuk-puppet'

library("govuk")

node {
  properties([
    buildDiscarder(logRotator(numToKeepStr: '50')),
  ])

  try {
    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(REPOSITORY)
    }

    stage("Merge main") {
      govuk.mergeIntoBranch("main")
    }

    stage("Bundle install") {
      govuk.bundleApp()
    }

    if (env.BRANCH_NAME != "main") {
      govuk.runRakeTask('shell:shellcheck[origin/main,HEAD]')
    }

    stage("puppet-librarian install") {
      govuk.runRakeTask('librarian:install')
    }

    stage("Spec tests") {
      lock("govuk-puppet-$NODE_NAME-test") {
        govuk.runRakeTask('all_but_lint')
      }
    }

    stage("Lint check") {
      govuk.runRakeTask('lint')
    }

    // Deploy on Integration (only main)
    if (env.BRANCH_NAME == "main") {
      stage("Push release tag") {
        echo 'Pushing tag'
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER, 'main')
      }

      stage("Deploy on Integration") {
        build job: 'Deploy_Puppet_Downstream',
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

  // Wipe the workspace
  deleteDir()
}
