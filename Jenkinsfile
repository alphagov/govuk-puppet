#!/usr/bin/env groovy

REPOSITORY = 'govuk-puppet'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Build") {

      // Explicitly set the path for the Jenkins swarm service on the agent
      env.PATH = "/usr/lib/rbenv/shims:/usr/lib/rbenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

      sh "${WORKSPACE}/jenkins.sh"
      if (env.BRANCH_NAME != 'master'){
        if (fileExists('build/puppet-lint-errors')) {
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
