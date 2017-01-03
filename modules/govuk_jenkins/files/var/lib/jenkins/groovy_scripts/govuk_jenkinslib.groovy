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
 * Ensure that the build parameters are set to their default values if they are
 * missing. This fixes an issue where the parameters are missing on the very
 * first pipeline build of a new branch (JENKINS-40574). They are set correctly
 * on every subsequent build, whether it is triggered automatically by a branch
 * push or manually by a Jenkins user.
 *
 * @param defaultBuildParams map of build parameter names to default values
 */
def initializeParameters(Map<String, String> defaultBuildParams) {
  for (param in defaultBuildParams) {
    if (env."${param.key}" == null) {
      setEnvar(param.key, param.value)
    }
  }
}

/**
 * Define Jenkins build parameters relating to content schema tests. These are
 * useful parameters to add to a build which can be run to test changes to the
 * content schemas, because they allow the schema build to trigger a build of
 * the project. The project build itself still needs to check for the values of
 * these parameters and handle them sensibly.
 *
 * @return array of build parameter definitions
 */
def schemaTestParameters() {
  return [
    [$class: 'BooleanParameterDefinition',
      name: 'IS_SCHEMA_TEST',
      defaultValue: false,
      description: 'Identifies whether this build is being triggered to test a change to the content schemas'],
    [$class: 'StringParameterDefinition',
      name: 'SCHEMA_BRANCH',
      defaultValue: DEFAULT_SCHEMA_BRANCH,
      description: 'The branch of govuk-content-schemas to test against']]
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
def rubyLinter(String dirs = 'app spec lib') {
  setEnvGitCommit()
  if (BRANCH_NAME != 'master') {
    echo 'Running Ruby linter'
    sh("bundle exec govuk-lint-ruby \
       --diff \
       --cached \
       --format html --out rubocop-${GIT_COMMIT}.html \
       --format clang \
       ${dirs}"
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
 * @param application ID of the application, which should match the ID
          configured in puppet and which is usually the same as the repository
          name
 * @param branch Branch name
 * @param tag Tag to deploy
 * @param deployTask Deploy task (deploy, deploy:migrations or deploy:setup)
 */
def deployIntegration(String application, String branch, String tag, String deployTask) {

  if (branch == 'master') {
    build job: 'integration-app-deploy', parameters: [string(name: 'TARGET_APPLICATION', value: application), string(name: 'TAG', value: tag), string(name: 'DEPLOY_TASK', value: deployTask)]
  }

}

return this;
