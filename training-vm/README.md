# GOV.UK Training environment

Follow the steps on this page to create a self-contained training environment.

## 1. Install some dependencies

  * [Vagrant](https://www.vagrantup.com/downloads.html)
  * [Terraform](https://www.terraform.io/)
  * vagrant-aws plugin: `vagrant plugin install vagrant-aws`

## 2. Boot your VM

1. Create a directory `./provisioner/.secrets` and add the GPG private key and
   passphrase files from the private repository.

2. Copy the `govuk-training` SSH private key from the private repository to a
   local directory.

3.1. Terraform:

  Export your AWS credentials and path to the `govuk-training` SSH private key.
  Alternatively, you can use a Terraform variables file, or var arguments, as
  explained in https://www.terraform.io/docs/configuration/variables.html.

  ```
  export TF_VAR_aws_access_key_id=<aws_access_key_id>
  export TF_VAR_aws_secret_access_key=<aws_secret_access_key>
  export TF_VAR_training_ssh_key_path=<path_to_govuk-training_ssh_key>
  ```

  Show potential changes

  ```
  terraform plan .
  ```

  Apply changes

  ```
  terraform  apply .
  ```

3.2. Vagrant

  Export your AWS credentials and path to the `govuk-training` SSH private key.

  ```
  AWS_ACCESS_KEY_ID=<aws_access_key_id>
  AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
  TRAINING_SSH_KEY_PATH=<path_to_govuk-training_ssh_key>
  ```

  We currently use environment variables for the security groups and subnet ID.

  ```
  export AWS_SUBNET=subnet-74dbee10
  export AWS_SECURITY_GROUPS=sg-805389f9
  ```

  Start the VM

  ```
  vagrant up
  ```

## 3. Run the apps

By default, the VM runs all the available apps using upstart scripts. You can
use the `stop-training-environment.sh` script in the `training-vm/provisioner`
directory to stop all the apps, and `start-training-environment.sh` to start
them again.

  ```
  ./start-training-environment.sh < alphagov_apps
  ```

The `bowl-training-environment.sh` script in the `development-vm` directory
starts the same apps but using bowler rather than upstart. This is intended
for development work on the training VM.
