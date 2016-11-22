#!/usr/bin/env groovy

REPOSITORY = 'govuk-puppet'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Build") {

      sh "${WORKSPACE}/jenkins.sh"
      if (env.BRANCH_NAME != 'master'){
        File file = new File("${WORKSPACE}/build/puppet-lint")
        if (file.exists() && file.length() > 0) {
          step([$class: 'GitHubCommitStatusSetter',
                statusResultSource: [$class: 'ConditionalStatusResultSource', 
                                     results: [[$class: 'BetterThanOrEqualBuildResult', 
                                                message: 'Build env.BUILD_NUMBER succeeded, but has lint!', 
                                                result: 'FAILURE', 
                                                state: 'ERROR']]
                                    ]
              ])
         }
      }
    }

    stage("Puppet-Lint warnings check") {
      step([$class: 'WarningsPublisher',
            consoleParsers: [], 
            defaultEncoding: '',
            failedNewAll: '',
            failedNewHigh: '',
            failedNewLow: '',
            failedNewNormal: '',
            failedTotalAll: '',
            failedTotalHigh: '', 
            failedTotalLow: '', 
            failedTotalNormal: '', 
            healthy: '', 
            parserConfigurations: [[parserName: 'Puppet-Lint', 
                                    pattern: 'build/puppet-lint']], 
            unHealthy: '', 
            unstableNewAll: '', 
            unstableNewHigh: '', 
            unstableNewLow: '', 
            unstableNewNormal: '', 
            unstableTotalAll: '', 
            unstableTotalHigh: '', 
            unstableTotalLow: '', 
            unstableTotalNormal: ''])
    }

    stage("Push release tag") {
      echo 'Pushing tag'
      //govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
    }

    // Deploy on Integration (only master)
    if (env.BRANCH_NAME == 'master'){
      stage("Deploy on Integration") {
        build job: 'integration-puppet-deploy', parameters: [string(name: 'TAG', value: 'release_' + env.BUILD_NUMBER)]
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
