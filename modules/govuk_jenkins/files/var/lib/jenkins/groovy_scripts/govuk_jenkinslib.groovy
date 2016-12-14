#!/usr/bin/env groovy

/*
 * Common functions for GOVUK Jenkinsfiles
 */

/**
 * Cleanup anything left from previous test runs
 */
def cleanupGit() {
  echo 'Cleaning up git'
  sh('git clean -fdx')
}

/**
 * Try to merge master into the current branch, and abort if it doesn't exit
 * cleanly (ie there are conflicts). This will be a noop if the current branch
 * is master.
 */
def mergeMasterBranch() {
  echo 'Attempting merge of master branch'
  sh('git merge --no-commit origin/master || git merge --abort')
}

/**
 * Sets environment variable
 *
 * @param key
 * @param value
 * Cannot iterate over maps in Jenkins2 currently
 */
def setEnvar(String key, String value) {
  echo 'Setting environment variable'
  env."${key}" = value
}

/**
 * Sets the current git commit in the env. Used by the linter
 */
def setEnvGitCommit() {
  env.GIT_COMMIT = sh (
      script: 'git rev-parse --short HEAD',
      returnStdout: true
  ).trim()
}

/**
 * Runs the ruby linter
 */
def rubyLinter() {
  setEnvGitCommit()
  if (BRANCH_NAME != 'master') {
    echo 'Running Ruby linter'
    sh("bundle exec govuk-lint-ruby \
       --diff \
       --cached \
       --format html --out rubocop-${GIT_COMMIT}.html \
       --format clang \
       app spec lib"
    )
  }
}

/**
 * Runs the SASS linter
 */
def sassLinter() {
  echo 'Running SASS linter'
  sh('bundle exec govuk-lint-sass app/assets/stylesheets')
}

/**
 * Precompiles assets
 */
def precompileAssets() {
  echo 'Precompiling the assets'
  sh('bundle exec rake assets:clean assets:precompile')
}

/**
 * Clone govuk-content-schemas dependency for contract tests
 */
def contentSchemaDependency(String schemaGitCommit = 'deployed-to-production') {
  sshagent(['govuk-ci-ssh-key']) {
    echo 'Cloning govuk-content-schemas'
    sh('rm -rf tmp/govuk-content-schemas')
    sh('git clone git@github.com:alphagov/govuk-content-schemas.git tmp/govuk-content-schemas')
    dir("tmp/govuk-content-schemas") {
      sh("git checkout ${schemaGitCommit}")
    }
  }
}

/**
 * Sets up test database
 */
def setupDb() {
  echo 'Setting up database'
  sh('bundle exec rails db:drop db:create db:environment:set db:schema:load')
}

/**
 * Bundles all the gems
 *
 */
def bundleApp() {
  echo 'Bundling'
  sh("bundle install --path ${JENKINS_HOME}/bundles/${JOB_NAME} --deployment --without development")
}

/**
 * Runs the tests
 *
 * @param test_task Optional test_task instead of 'default'
 */
def runTests(String test_task = 'default') {
  echo 'Running tests'
  sh("bundle exec rails ${test_task}")
}

/**
 * Runs rake task
 *
 * @param task Task to run
 */
def runRakeTask(String rake_task) {
  echo "Running ${rake_task} task"
  sh("bundle exec rake ${rake_task}")
}

/**
 * Push tags to Github repository
 *
 * @param repository Github repository
 * @param branch Branch name
 * @param tag Tag name
 */
def pushTag(String repository, String branch, String tag) {

  if (branch == 'master'){
    echo 'Pushing tag'
    sshagent(['govuk-ci-ssh-key']) {
      sh("git tag -a ${tag} -m 'Jenkinsfile tagging with ${tag}'")
      echo "Tagging alphagov/${repository} master branch -> ${tag}"
      sh("git push git@github.com:alphagov/${repository}.git ${tag}")
      echo "Updating alphagov/${repository} release branch"
      sh("git push git@github.com:alphagov/${repository}.git HEAD:release")
    }
  } else {
    echo 'No tagging on branch'
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

  if (branch == 'master') {
    // Deploy on Integration
    stage('Deploy on Integration') {
      build job: 'integration-app-deploy', parameters: [string(name: 'TARGET_APPLICATION', value: repository), string(name: 'TAG', value: tag), string(name: 'DEPLOY_TASK', value: deployTask)]
    }
  }

}

return this;
