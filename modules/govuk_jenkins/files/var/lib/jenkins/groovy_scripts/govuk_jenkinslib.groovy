#!/usr/bin/env groovy

/*
 * Common functions for GOVUK Jenkinsfiles
 */

/**
 * Cleanup anything left from previous test runs
 */
def cleanupGit() {
  echo 'Cleaning up git'
  withStatsdTiming("cleanup_git") {
    sh('git clean -fdx')
  }
}

/**
 * Checkout repo using SSH key
 */
def checkoutFromGitHubWithSSH(String repository, String org = 'alphagov', String url = 'github.com') {
  withStatsdTiming("github_ssh_checkout") {
    checkout([$class: 'GitSCM',
      branches: scm.branches,
      userRemoteConfigs: [[
        credentialsId: 'govuk-ci-ssh-key',
        url: "git@${url}:${org}/${repository}.git"
      ]]
    ])
  }
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

    withStatsdTiming("ruby_lint") {
      sh("bundle exec govuk-lint-ruby \
         --diff \
         --cached \
         --format html --out rubocop-${GIT_COMMIT}.html \
         --format clang \
         ${dirs}"
      )
    }
  }
}

/**
 * Runs the SASS linter
 */
def sassLinter(String dirs = 'app/assets/stylesheets') {
  echo 'Running SASS linter'
  withStatsdTiming("sass_lint") {
    sh("bundle exec govuk-lint-sass ${dirs}")
  }
}

/**
 * Precompiles assets
 */
def precompileAssets() {
  echo 'Precompiling the assets'
  withStatsdTiming("assets_precompile") {
    sh('bundle exec rake assets:clean assets:precompile')
  }
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
  withStatsdTiming("setup_db") {
    sh('RAILS_ENV=test bundle exec rake db:environment:set db:drop db:create db:schema:load')
  }
}

/**
 * Bundles all the gems in deployment mode
 */
def bundleApp() {
  echo 'Bundling'
  withStatsdTiming("bundle") {
    lock ("bundle_install-$NODE_NAME") {
      sh("bundle install --path ${JENKINS_HOME}/bundles --deployment --without development")
    }
  }
}

/**
 * Bundles all the gems
 */
def bundleGem() {
  echo 'Bundling'
  withStatsdTiming("bundle") {
    lock ("bundle_install-$NODE_NAME") {
      sh("bundle install --path ${JENKINS_HOME}/bundles")
    }
  }
}

/**
 * Runs the tests
 *
 * @param test_task Optional test_task instead of 'default'
 */
def runTests(String test_task = 'default') {
  withStatsdTiming("test_task") {
    sh("bundle exec rake ${test_task}")
  }
}

/**
 * Runs rake task
 *
 * @param task Task to run
 */
def runRakeTask(String rake_task) {
  echo "Running ${rake_task} task"
  withStatsdTiming("rake") {
    sh("bundle exec rake ${rake_task}")
  }
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

      // TODO: pushTag would be better if it only did exactly that,
      // but lots of Jenkinsfiles expect it to also update the release
      // branch. There are cases where release branches are not used
      // (e.g. repositories containing Ruby gems). For now, just check
      // if the release branch exists on the remote, and only push to it
      // if it does.
      def releaseBranchExists = sh(
        script: "git ls-remote --exit-code --refs origin release",
        returnStatus: true
      ) == 0

      if (releaseBranchExists) {
        echo "Updating alphagov/${repository} release branch"
        sh("git push git@github.com:alphagov/${repository}.git HEAD:refs/heads/release")
      }
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

  def escapedVersion = version.replaceAll(/\./, /\\\\./)
  def versionAlreadyPublished = sh(
    script: /gem list ^${repository}\$ --remote --all --quiet | grep [^0-9\\.]${escapedVersion}[^0-9\\.]/,
    returnStatus: true
  ) == 0

  if (versionAlreadyPublished) {
    echo "Version ${version} has already been published to rubygems.org. Skipping publication."
  } else {
    echo('Publishing gem')
    sh("gem build ${repository}.gemspec")
    sh("gem push ${repository}-${version}.gem")
  }

  def taggedReleaseExists = false

  sshagent(['govuk-ci-ssh-key']) {
    taggedReleaseExists = sh(
      script: "git ls-remote --exit-code --tags origin v${version}",
      returnStatus: true
    ) == 0
  }

  if (taggedReleaseExists) {
    echo "Version ${version} has already been tagged on Github. Skipping publication."
  } else {
    echo('Pushing tag')
    pushTag(repository, branch, 'v' + version)
  }
}

/**
 * Time the function and send the result to statsd
 * @param key The key for statsd. The stats will be available in graphite under
 * `stats.timers.ci.APP_NAME.KEY_NAME`
 * @param fn Function to execute
 */
def withStatsdTiming(key, fn) {
  start = System.currentTimeMillis()

  fn()

  now = System.currentTimeMillis()
  runtime = now - start

  project_name = JOB_NAME.split('/')[0]
  sh 'echo "ci.' + project_name + '.' + key + ':' + runtime + '|ms" | nc -w 1 -u localhost 8125'
}

/**
 * Build the project
 * @param sassLint Whether or not to run the SASS linter
 */
def buildProject(sassLint = true) {
  repoName = JOB_NAME.split('/')[0]

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ParametersDefinitionProperty',
      parameterDefinitions: [
        [$class: 'BooleanParameterDefinition',
          name: 'IS_SCHEMA_TEST',
          defaultValue: false,
          description: 'Identifies whether this build is being triggered to test a change to the content schemas'],
        [$class: 'StringParameterDefinition',
          name: 'SCHEMA_BRANCH',
          defaultValue: 'deployed-to-production',
          description: 'The branch of govuk-content-schemas to test against'],
        [$class: 'StringParameterDefinition',
          name: 'SCHEMA_COMMIT',
          defaultValue: 'invalid',
          description: 'The commit of govuk-content-schemas that triggered this build, if it is a schema test']],
    ],
  ])

  try {
    if (!isAllowedBranchBuild(env.BRANCH_NAME)) {
      return
    }

    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(repoName, params.SCHEMA_COMMIT, "Downstream ${repoName} job is building on Jenkins", 'PENDING')
    }

    stage("Checkout") {
      checkoutFromGitHubWithSSH(repoName)
    }

    stage("Clean up workspace") {
      cleanupGit()
    }

    stage("Merge master") {
      mergeMasterBranch()
    }

    stage("Configure environment") {
      setEnvar("RAILS_ENV", "test")
      setEnvar("RACK_ENV", "test")
      setEnvar("DISPLAY", ":99")
    }

    stage("Set up content schema dependency") {
      contentSchemaDependency(params.SCHEMA_BRANCH)
      setEnvar("GOVUK_CONTENT_SCHEMAS_PATH", "tmp/govuk-content-schemas")
    }

    stage("bundle install") {
      if (isGem()) {
        bundleGem()
      } else {
        bundleApp()
      }
    }

    if (hasLint()) {
      stage("Lint Ruby") {
        rubyLinter("app lib spec test")
      }
    } else {
      echo "WARNING: You do not have Ruby linting turned on. Please install govuk-lint and enable."
    }

    if (hasAssets() && hasLint() && sassLint) {
      stage("Lint SASS") {
        sassLinter()
      }
    } else {
      echo "WARNING: You do not have SASS linting turned on. Please install govuk-lint and enable."
    }

    // Prevent a project's tests from running in parallel on the same node
    lock("$repoName-$NODE_NAME-test") {
      if (hasDatabase()) {
        stage("Set up the database") {
            runRakeTask("db:drop db:create db:schema:load")
        }
      }

      stage("Run tests") {
        runTests()
      }
    }

    if (hasAssets() && !params.IS_SCHEMA_TEST) {
      stage("Precompile assets") {
        precompileAssets()
      }
    }

    if (env.BRANCH_NAME == "master") {
      if (isGem()) {
        stage("Publish Gem to Rubygems") {
          publishGem(repoName, env.BRANCH_NAME)
        }
      } else {
        stage("Push release tag") {
          pushTag(repoName, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
        }

        stage("Deploy to integration") {
          deployIntegration(repoName, env.BRANCH_NAME, 'release', 'deploy')
        }
      }
    }
    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(repoName, params.SCHEMA_COMMIT, "Downstream ${repoName} job succeeded on Jenkins", 'SUCCESS')
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(repoName, params.SCHEMA_COMMIT, "Downstream ${repoName} job failed on Jenkins", 'FAILED')
    }
    throw e
  }
}

/**
 * Does this project use Rails-style assets?
 */
def hasAssets() {
  sh(script: "test -d app/assets", returnStatus: true) == 0
}

/**
 * Does this project use GOV.UK lint?
 */
def hasLint() {
  sh(script: "grep 'govuk-lint' Gemfile.lock", returnStatus: true) == 0
}

/**
 * Is this a Ruby gem?
 *
 * Determined by checking the presence of a `.gemspec` file
 */
def isGem() {
  sh(script: "ls | grep gemspec", returnStatus: true) == 0
}

/**
 * Does this project use a Rails-style database?
 *
 * Determined by checking the presence of a `database.yml` file
 */
def hasDatabase() {
  sh(script: "test -e config/database.yml", returnStatus: true) == 0
}

/**
 * Manually set build status in Github.
 *
 * Useful for downstream builds that want to report on the upstream PR.
 *
 * @param repoName Name of the repo being built
 * @param commit SHA of the triggering commit on govuk-content-schemas
 * @param message The message to report
 * @param state The build state: one of PENDING, SUCCESS, FAILED
 */
def setBuildStatus(repoName, commit, message, state) {
  step([
      $class: "GitHubCommitStatusSetter",
      commitShaSource: [$class: "ManuallyEnteredShaSource", sha: commit],
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/alphagov/govuk-content-schemas"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "continuous-integration/jenkins/${repoName}"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

return this;
