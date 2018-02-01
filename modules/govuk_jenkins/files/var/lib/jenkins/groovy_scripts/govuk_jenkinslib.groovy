#!/usr/bin/env groovy

/**
 * # Setting up CI on GOV.UK
 *
 * For most Ruby projects, the following `Jenkinsfile` is sufficient:
 *
 * ```groovy
 * #!/usr/bin/env groovy
 *
 * node {
 *   def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
 *   govuk.buildProject()
 * }
 * ```
 *
 * This will set up dependencies, run the tests and report back to GitHub.
 *
 * For applications: the `master` branch of applications will be deployed to integration
 *
 * For gems: if the version has changed, the latest version will be released to rubygems.org
 *
 * ## Exceptions
 *
 * If you use `govuk-lint` but aren't linting your SASS yet (you should), you can
 * disable linting:
 *
 * ```groovy
 * #!/usr/bin/env groovy
 *
 * node {
 *   def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
 *   govuk.buildProject(sassLint: false)
 * }
 * ```
 *
 * If you need to run tests using a command other than the default rake task
 * you can do this by specifying the `overrideTestTask` option:
 *
 * ```groovy
 * #!/usr/bin/env groovy
 *
 * node {
 *   def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
 *
 *   govuk.buildProject(overrideTestTask: {
 *     stage("Run custom tests") {
 *       govuk.runRakeTask("super-special-tests")
 *     }
 *   })
 * }
 *```
 *
 * @param options Map of build options:
 *        - sassLint Whether or not to run the SASS linter. Default: true
 *        - extraRubyVersions Ruby versions to run the tests against in
 *          addition to the versions currently supported by all GOV.UK
 *          applications. Only applies to gems because they may be used in
 *          projects with different Ruby versions. Default: []
 *        - beforeTest A closure containing commands to run before the test
 *          stage, such as environment variable configuration
 *        - overrideTestTask A closure containing commands to run to test the
 *          project. This will run instead of the default `bundle exec rake`
 *        - publishingE2ETests Whether or not to run the Publishing end-to-end
 *          tests.  Default: false
 *        - afterTest A closure containing commands to run after the test stage,
 *          such as report publishing
 *        - newStyleDockerTags Tag docker images with timestamp and git SHA
 *          rather than the default of the build number
 *        - repoName Provide this if the Github Repo name for the app is
 *          different to the jenkins job name.
 *        - extraParameters Provide details here of any extra parameters that
 *          can be used to configure this build.  See: https://jenkins.io/doc/pipeline/steps/workflow-multibranch/#code-properties-code-set-job-properties
 *          for details on the format and structure of these extra parameters.
 */
def buildProject(Map options = [:]) {

  def jobName = JOB_NAME.split('/')[0]
  def repoName
  if (options.repoName) {
    repoName = options.repoName
  } else {
    repoName = jobName
  }

  def parameterDefinitions = [
    [$class: 'BooleanParameterDefinition',
      name: 'IS_SCHEMA_TEST',
      defaultValue: false,
      description: 'Identifies whether this build is being triggered to test a change to the content schemas'],
    [$class: 'BooleanParameterDefinition',
      name: 'PUSH_TO_GCR',
      defaultValue: false,
      description: '--TESTING ONLY-- Whether to push the docker image to Google Container Registry.'],
    [$class: 'StringParameterDefinition',
      name: 'SCHEMA_BRANCH',
      defaultValue: 'deployed-to-production',
      description: 'The branch of govuk-content-schemas to test against'],
    [$class: 'StringParameterDefinition',
      name: 'SCHEMA_COMMIT',
      defaultValue: 'invalid',
      description: 'The commit of govuk-content-schemas that triggered this build, if it is a schema test']
  ]

  if (options.extraParameters) {
    parameterDefinitions.addAll(options.extraParameters)
  }

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ParametersDefinitionProperty', parameterDefinitions: parameterDefinitions],
  ])

  def defaultParameterValuesMap = [:]
  parameterDefinitions.each {
    // to handle params defined with the xxxParam(...) DSL instead of
    // [$class: ... ] style because we can't call .name / .defaultValue
    // on them directly
    if (it.class == org.jenkinsci.plugins.structs.describable.UninstantiatedDescribable) {
      def mapVersionOfIt = it.toMap()
      defaultParameterValuesMap[mapVersionOfIt.name] = mapVersionOfIt.defaultValue
    } else {
      defaultParameterValuesMap[it.name] = it.defaultValue
    }
  }
  initializeParameters(defaultParameterValuesMap)

  try {
    if (!isAllowedBranchBuild(env.BRANCH_NAME)) {
      return
    }

    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(jobName, params.SCHEMA_COMMIT, "Downstream ${jobName} job is building on Jenkins", 'PENDING')
    }

    stage("Checkout") {
      checkoutFromGitHubWithSSH(repoName)
    }

    stage("Merge master") {
      mergeMasterBranch()
    }

    stage("Configure environment") {
      setEnvar("DISABLE_DATABASE_ENVIRONMENT_CHECK", "1")
      setEnvar("RAILS_ENV", "test")
      setEnvar("RACK_ENV", "test")
      setEnvar("DISPLAY", ":99")
    }

    if (hasDockerfile() && !params.IS_SCHEMA_TEST) {
      parallel (
        "build" : { nonDockerBuildTasks(options, jobName, repoName) },
        "docker" : { dockerBuildTasks(options, jobName) }
      )
    } else {
      nonDockerBuildTasks(options, jobName, repoName)
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

        stage("Push to Gitlab") {
          try {
            pushToMirror(repoName, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
          } catch (e) {
          }
        }

        if (hasDockerfile()) {
          stage("Tag Docker image") {
            dockerTagMasterBranch(jobName, env.BRANCH_NAME, env.BUILD_NUMBER, options.newStyleDockerTags)
          }
        }

        stage("Deploy to integration") {
          deployIntegration(jobName, env.BRANCH_NAME, "release_${env.BUILD_NUMBER}", 'deploy')
        }
      }
    }
    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(jobName, params.SCHEMA_COMMIT, "Downstream ${jobName} job succeeded on Jenkins", 'SUCCESS')
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    if (params.IS_SCHEMA_TEST) {
      setBuildStatus(jobName, params.SCHEMA_COMMIT, "Downstream ${jobName} job failed on Jenkins", 'FAILED')
    }
    throw e
  }
}

def nonDockerBuildTasks(options, jobName, repoName) {
  contentSchemaDependency(params.SCHEMA_BRANCH)

  stage("bundle install") {
    isGem() ? bundleGem() : bundleApp()
  }

  if (hasLint()) {
    stage("Lint Ruby") {
      rubyLinter("app lib spec test")
    }
  } else {
    echo "WARNING: You do not have Ruby linting turned on. Please install govuk-lint and enable."
  }

  if (hasAssets() && hasLint() && options.sassLint != false) {
    stage("Lint SASS") {
      sassLinter()
    }
  } else {
    echo "WARNING: You do not have SASS linting turned on. Please install govuk-lint and enable."
  }

  if (options.beforeTest) {
    echo "Running pre-test tasks"
    options.beforeTest.call()
  }

  // Prevent a project's tests from running in parallel on the same node
  lock("$jobName-$NODE_NAME-test") {
    if (hasDatabase()) {
      stage("Set up the database") {
          runRakeTask("db:reset")
      }
    }

    if (options.overrideTestTask) {
      echo "Running custom test task"
      options.overrideTestTask.call()
    } else {
      if (isGem()) {
        def extraRubyVersions = options.extraRubyVersions == null ? [] : options.extraRubyVersions
        testGemWithAllRubies(extraRubyVersions)
      } else {
        stage("Run tests") {
          runTests()
        }
      }
    }
  }

  if (options.publishingE2ETests == true && !params.IS_SCHEMA_TEST) {
    stage("End-to-end tests") {
      if ( env.PUBLISHING_E2E_TESTS_APP_PARAM == null ) {
        appCommitishName = jobName.replace("-", "_").toUpperCase() + "_COMMITISH"
      } else {
        appCommitishName = env.PUBLISHING_E2E_TESTS_APP_PARAM
      }
      if ( env.PUBLISHING_E2E_TESTS_BRANCH == null ) {
        testBranch = "test-against"
      } else {
        testBranch = env.PUBLISHING_E2E_TESTS_BRANCH
      }
      if ( env.PUBLISHING_E2E_TESTS_COMMAND == null ) {
        testCommand = "test"
      } else {
        testCommand = env.PUBLISHING_E2E_TESTS_COMMAND
      }
      runPublishingE2ETests(appCommitishName, testBranch, repoName, testCommand)
    }
  }

  if (options.afterTest) {
    echo "Running post-test tasks"
    options.afterTest.call()
  }

  if (hasAssets() && !params.IS_SCHEMA_TEST) {
    stage("Precompile assets") {
      precompileAssets()
    }
  }
}

def dockerBuildTasks(options, jobName) {
  stage("Build Docker image") {
    buildDockerImage(jobName, env.BRANCH_NAME, true)
  }

  if (!(env.BRANCH_NAME ==~ /^deployed-to/)) {
    stage("Push Docker image") {
      pushDockerImage(jobName, env.BRANCH_NAME)

      if (params.PUSH_TO_GCR) {
        pushDockerImageToGCR(jobName, env.BRANCH_NAME)
      }
    }
  }
}

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
def checkoutFromGitHubWithSSH(String repository, Map options = [:]) {
  def defaultOptions = [
    branch: null,
    changelog: true,
    location: null,
    org: "alphagov",
    poll: true,
    host: "github.com"
  ]
  options = defaultOptions << options

  def branches
  if (options.branch) {
    branches = [[ name: options.branch ]]
  } else {
    branches = scm.branches
  }

  def extensions = [
    [
      $class: "CleanCheckout"
    ]
  ]

  if(options.directory) {
    extensions << [
      $class: "RelativeTargetDirectory",
      relativeTargetDir: options.directory
    ]
  }

  withStatsdTiming("github_ssh_checkout") {
    checkout([
      changelog: options.changelog,
      poll: options.poll,
      scm: [
        $class: 'GitSCM',
        branches: branches,
        doGenerateSubmoduleConfigurations: false,
        extensions: extensions,
        submoduleCfg: [],
        userRemoteConfigs: [[
          credentialsId: 'govuk-ci-ssh-key',
          url: "git@${options.host}:${options.org}/${repository}.git"
        ]]
      ]
    ])
  }
}

/**
 * Checkout a dependent repo.
 * This function acts as a wrapper around checkoutFromGitHubWithSSH with
 * options tailored towards the needs of a secondary repo cloned as part of a
 * pipeline job
 *
 * It can accept an optional closure that is run within the directory that has
 * been cloned
 */
def checkoutDependent(String repository, options = [:], Closure closure = null) {
  def defaultOptions = [
    branch: "master",
    changelog: false,
    directory: "tmp/${repository}",
    poll: false
  ]
  options = defaultOptions << options

  stage("Cloning ${repository}") {
    checkoutFromGitHubWithSSH(repository, options)
  }

  if (closure) {
    dir(options.directory) {
      closure.call()
    }
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
 * Check whether there is a git branch named release
 * This test is useful for determining whether we should update this branch or
 * not
 */
def releaseBranchExists() {
  sshagent(["govuk-ci-ssh-key"]) {
    sh(
      script: "git ls-remote --exit-code --refs origin release",
      returnStatus: true
    ) == 0
  }
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
 * Note: for scope-related reasons the code in here is inlined directly
 * in the initializeParameters method below, if you change our version
 * you should update it there too.
 *
 * @param key
 * @param value
 */
def setEnvar(String key, String value) {
  echo "Setting environment variable ${key}"
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
 * This doesn't use setEnvar because for some scope-related reason we couldn't
 * work out, first builds would fail because it couldn't find setEnvar. We
 * inline the code instead.
 *
 * @param defaultBuildParams map of build parameter names to default values
 */
def initializeParameters(Map<String, String> defaultBuildParams) {
  for (param in defaultBuildParams) {
    if (env."${param.key}" == null) {
      echo "Setting environment variable ${param.key}"
      env."${param.key}" = param.value
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

def getGitCommit() {
  return sh(
      script: 'git rev-parse --short HEAD',
      returnStdout: true
  ).trim()
}

/**
 * Sets the current git commit in the env. Used by the linter
 */
def setEnvGitCommit() {
  env.GIT_COMMIT = getGitCommit()
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
    sh('RAILS_ENV=production GOVUK_WEBSITE_ROOT=http://www.test.gov.uk GOVUK_APP_DOMAIN=test.gov.uk GOVUK_APP_DOMAIN_EXTERNAL=test.gov.uk GOVUK_ASSET_ROOT=https://static.test.gov.uk GOVUK_ASSET_HOST=https://static.test.gov.uk bundle exec rake assets:clobber assets:precompile')
  }
}

/**
 * Clone govuk-content-schemas dependency for contract tests
 */
def contentSchemaDependency(String schemaGitCommit = 'deployed-to-production') {
  checkoutDependent("govuk-content-schemas", [ branch: schemaGitCommit ]) {
    setEnvar("GOVUK_CONTENT_SCHEMAS_PATH", pwd())
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
 * Runs the tests with all the Ruby versions that are currently supported.
 *
 * Adds a Jenkins stage for each Ruby version, so do not call this from within
 * a stage.
 *
 * @param extraRubyVersions Optional Ruby versions to run the tests against in
 * addition to the versions currently supported by all GOV.UK applications
 */
def testGemWithAllRubies(extraRubyVersions = []) {
  def rubyVersions = ["2.3", "2.4", "2.5"]

  rubyVersions.addAll(extraRubyVersions)

  for (rubyVersion in rubyVersions) {
    stage("Test with ruby $rubyVersion") {
      sh "rm -f Gemfile.lock"
      setEnvar("RBENV_VERSION", rubyVersion)
      bundleGem()

      runTests()
    }
  }
  sh "unset RBENV_VERSION"
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
      if (releaseBranchExists()) {
        echo "Updating alphagov/${repository} release branch"
        sh("git push git@github.com:alphagov/${repository}.git HEAD:refs/heads/release")
      }
    }
  } else {
    echo 'No tagging on branch'
  }
}

def pushToMirror(String repository, String branch, String tag) {
  if (branch == 'master'){
    withCredentials([string(credentialsId: 'gitlab-govuk-ci', variable: 'TOKEN')]) {
      mirrorUrl = "https://govuk-ci:$TOKEN@gitlab.com/govuk/${repository}.git"

      echo 'Pushing master branch to Gitlab'
      sh("git push ${mirrorUrl} HEAD:refs/heads/${branch} --force")

      echo 'Pushing tag to Gitlab'
      sh("git push ${mirrorUrl} ${tag}")
    }
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
    ], wait: false
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

def hasDockerfile() {
  sh(script: "test -e Dockerfile", returnStatus: true) == 0
}

def buildDockerImage(imageName, tagName, quiet = false) {
  tagName = safeDockerTag(tagName)
  args = quiet ? "--quiet ." : "."
  docker.build("govuk/${imageName}:${tagName}", args)
}

/**
 */
def dockerTagMasterBranch(jobName, branchName, buildNumber, newStyleDockerTags = false) {
  dockerTag = newStyleDockerTags ? getNewStyleReleaseTag() : "release_${buildNumber}"
  pushDockerImage(jobName, branchName, dockerTag)

  if (releaseBranchExists()) {
    pushDockerImage(jobName, branchName, "release")
  }
}

/*
 * Push the image to the govuk docker hub and tag it. If `asTag` is set then
 * the image is also tagged with that value otherwise the `tagName` is used.
 */
def pushDockerImage(imageName, tagName, asTag = null) {
  tagName = safeDockerTag(tagName)
  docker.withRegistry('https://index.docker.io/v1/', 'govukci-docker-hub') {
    docker.image("govuk/${imageName}:${tagName}").push(asTag ?: tagName)
  }
}

def pushDockerImageToGCR(imageName, tagName) {
  tagName = safeDockerTag(tagName)
  gcrName = "gcr.io/govuk-test/${imageName}"
  docker.build(gcrName)

  withCredentials([file(credentialsId: 'govuk-test', variable: 'GCR_CRED_FILE')]) {
    // We don't want to interpolate this command as GCR_CRED_FILE is set as an
    // environment variable in bash.
    command = 'gcloud auth activate-service-account --key-file "$GCR_CRED_FILE"'
    sh command
    // We do want to interpolate this command to get the value of gcrName
    command = "gcloud docker -- push ${gcrName}"
    sh command
    // Add the tag, again this needs to be interpolated
    command = "gcloud container images add-tag ${gcrName} ${gcrName}:${tagName}"
    sh command
  }
}

def safeDockerTag(tagName) {
  return tagName.replace("/", "_")
}

/*
 * Upload the artefact at artefact_path to the given s3_path. Uses the
 * govuk-s3-artefact-creds for access.
 */
def uploadArtefactToS3(artefact_path, s3_path){
  withCredentials([[$class: 'UsernamePasswordMultiBinding',
                     credentialsId: 'govuk-s3-artefact-creds',
                     usernameVariable: 'AWS_ACCESS_KEY_ID',
                     passwordVariable: 'AWS_SECRET_ACCESS_KEY']]){
    sh "s3cmd --region eu-west-1 --acl-public --access_key $AWS_ACCESS_KEY_ID --secret_key $AWS_SECRET_ACCESS_KEY put $artefact_path $s3_path"
  }
}

/*
 * Return string formatted to the new tag style of `release_<timestamp>_<sha>`
 */
def getNewStyleReleaseTag(){
  gitCommit = getGitCommit()
  timestamp = sh(returnStdout: true, script: 'date +%s').trim()
  return "release_${timestamp}_${gitCommit}"
}

/**
 * Manually set build status in Github.
 *
 * Useful for downstream builds that want to report on the upstream PR.
 *
 * @param jobName Name of the jenkins job being built
 * @param commit SHA of the triggering commit on govuk-content-schemas
 * @param message The message to report
 * @param state The build state: one of PENDING, SUCCESS, FAILED
 */
def setBuildStatus(jobName, commit, message, state) {
  step([
      $class: "GitHubCommitStatusSetter",
      commitShaSource: [$class: "ManuallyEnteredShaSource", sha: commit],
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/alphagov/govuk-content-schemas"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "continuous-integration/jenkins/${jobName}"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

def runPublishingE2ETests(appCommitishName, testBranch, repo, testCommand = "test") {
  fullCommitHash = getFullCommitHash()
  build(
    job: "publishing-e2e-tests/${testBranch}",
    parameters: [
      [$class: "StringParameterValue",
        name: appCommitishName,
        value: fullCommitHash],
      [$class: "StringParameterValue",
        name: "TEST_COMMAND",
        value: testCommand],
      [$class: "StringParameterValue",
        name: "ORIGIN_REPO",
        value: repo],
      [$class: "StringParameterValue",
        name: "ORIGIN_COMMIT",
        value: fullCommitHash]
    ],
    wait: false,
  )
}

def getFullCommitHash() {
  return sh(
    script: "git rev-parse HEAD",
    returnStdout: true
  ).trim()
}

return this;
