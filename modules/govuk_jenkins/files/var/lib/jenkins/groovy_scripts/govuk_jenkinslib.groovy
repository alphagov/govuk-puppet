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
 * Checkout repo using SSH key
 */
def checkoutFromGitHubWithSSH(String repository, String org = 'alphagov', String url = 'github.com') {
  checkout([$class: 'GitSCM',
    branches: scm.branches,
    userRemoteConfigs: [[
      credentialsId: 'govuk-ci-ssh-key',
      url: "git@${url}:${org}/${repository}.git"
    ]]
  ])
}

/**
  * Check if the git HEAD is ahead of master.
  * This will be false for development branches and true for release branches,
  * and master itself.
  */
def isCurrentCommitOnMaster() {
  sh(
    script: 'git rev-list origin/master | grep $(git rev-parse HEAD)',
    returnStatus: true
  ) == 0
}

/**
 * Try to merge master into the current branch
 *
 * This will abort if it doesn't exit cleanly (ie there are conflicts), and
 * will be a noop if the current branch is master or is in the history for
 * master, e.g. a previously-merged dev branch or the deployed-to-production
 * branch.
 */
def mergeMasterBranch() {
  if (isCurrentCommitOnMaster()) {
    echo "Current commit is on master, so building this branch without " +
      "merging in master branch."
  } else {
    echo "Current commit is not on master, so attempting merge of master " +
      "branch before proceeding with build"
    sh('git merge --no-commit origin/master || git merge --abort')
  }
}

/**
 * Sets environment variable
 *
 * Cannot iterate over maps in Jenkins2 currently
 *
 * @param key
 * @param value
 */
def setEnvar(String key, String value) {
  echo 'Setting environment variable'
  env."${key}" = value
}

/**
 * Ensure missing build parameters are set to their default values
 *
 * This fixes an issue where the parameters are missing on the very first
 * pipeline build of a new branch (JENKINS-40574). They are set correctly on
 * every subsequent build, whether it is triggered automatically by a branch
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
 * Check whether the Jenkins build should be run for the current branch
 *
 * Builds can be run if it's against a regular branch build or if it is
 * being run to test the content schema.
 *
 * Jenkinsfiles should run this check if the project is used to test updates
 * to the content schema. Other projects should be configured in Puppet to
 * exclude builds of non-dev branches, so this check is unnecessary.
 */
def isAllowedBranchBuild(
  String currentBranchName,
  String deployedBranchName = "deployed-to-production") {

  if (currentBranchName == deployedBranchName) {
    if (params.IS_SCHEMA_TEST) {
      echo "Branch is '${deployedBranchName}' and this is a schema test " +
        "build. Proceeding with build."
      return true
    } else {
      echo "Branch is '${deployedBranchName}', but this is not marked as " +
        "a schema test build. '${deployedBranchName}' should only be " +
        "built as part of a schema test, so this build will stop here."
      return false
    }
  }

  echo "Branch is '${currentBranchName}', so this is a regular dev branch " +
    "build. Proceeding with build."
  return true
}

/**
 * Sets the current git commit in the env. Used by the linter
 */
def setEnvGitCommit() {
  env.GIT_COMMIT = sh(
      script: 'git rev-parse --short HEAD',
      returnStdout: true
  ).trim()
}

/**
 * Runs the ruby linter. Only lint commits that are not in master.
 */
def rubyLinter(String dirs = 'app spec lib') {
  setEnvGitCommit()
  if (!isCurrentCommitOnMaster()) {
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
def sassLinter(String dirs = 'app/assets/stylesheets') {
  echo 'Running SASS linter'
  sh("bundle exec govuk-lint-sass ${dirs}")
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
    env."GOVUK_CONTENT_SCHEMAS_PATH" = "tmp/govuk-content-schemas"
  }
}

/**
 * Sets up test database
 */
def setupDb() {
  echo 'Setting up database'
  sh('RAILS_ENV=test bundle exec rake db:environment:set db:drop db:create db:schema:load')
}

/**
 * Bundles all the gems in deployment mode
 */
def bundleApp() {
  echo 'Bundling'
  sh("bundle install --path ${JENKINS_HOME}/bundles/${JOB_NAME} --deployment --without development")
}

/**
 * Bundles all the gems
 */
def bundleGem() {
  echo 'Bundling'
  sh("bundle install --path ${JENKINS_HOME}/bundles/${JOB_NAME}")
}

/**
 * Runs the tests
 *
 * @param test_task Optional test_task instead of 'default'
 */
def runTests(String test_task = 'default') {
  echo 'Running tests'
  sh("bundle exec rake ${test_task}")
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
    }
  } else {
    echo 'No tagging on branch'
  }
}

/**
 * Deploy application on the Integration environment
 *
 * @param application ID of the application, which should match the ID
 *        configured in puppet and which is usually the same as the repository
 *        name
 * @param branch Branch name
 * @param tag Tag to deploy
 * @param deployTask Deploy task (deploy, deploy:migrations or deploy:setup)
 */
def deployIntegration(String application, String branch, String tag, String deployTask) {
  if (branch == 'master') {
    build job: 'integration-app-deploy', parameters: [
      string(name: 'TARGET_APPLICATION', value: application),
      string(name: 'TAG', value: tag),
      string(name: 'DEPLOY_TASK', value: deployTask)
    ]
  }
}

/**
 * Publish a gem to rubygems.org
 *
 * @param repository Name of the gem repository. This should match the name of the gemspec file.
 * @param branch Branch name being published. Only publishes if this is 'master'
 */
def publishGem(String repository, String branch) {
  if (branch != 'master') {
    return
  }

  def version = sh(
    script: /ruby -e "puts eval(File.read('${repository}.gemspec'), TOPLEVEL_BINDING).version.to_s"/,
    returnStdout: true
  ).trim()

  sshagent(['govuk-ci-ssh-key']) {
    echo "Fetching remote tags"
    sh("git fetch --tags")
  }

  def taggedReleaseExists = sh(
    script: "git tag | grep v${version}",
    returnStatus: true
  ) == 0

  if (taggedReleaseExists) {
    echo "Version ${version} has already been tagged on Github. Skipping publication."
    return
  } else {
    echo('Pushing tag')
    pushTag(repository, branch, 'v' + version)
  }

  def escapedVersion = version.replaceAll(/\./, /\\\\./)
  def versionAlreadyPublished = sh(
    script: /gem list ^${repository}\$ --remote --all --quiet | grep [^0-9\\.]${escapedVersion}[^0-9\\.]/,
    returnStatus: true
  ) == 0

  if (versionAlreadyPublished) {
    echo "Version ${version} has already been published to rubygems.org. Skipping publication."
    return
  } else {
    echo('Publishing gem')
    sh("gem build ${repository}.gemspec")
    sh("gem push ${repository}-${version}.gem")
  }
}

return this;
