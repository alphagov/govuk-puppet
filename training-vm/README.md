# GOV.UK Training environment (DRAFT)

The following instructions show how to build a self-contained training VM.

## 1. Prerequisites

Vagrant:

  * [Vagrant](https://www.vagrantup.com/downloads.html) installed
  * vagrant-aws plugin installed ` vagrant plugin install vagrant-aws `

Terraform:

  * [Terraform](https://www.terraform.io/) installed

## 2. Booting the VM

1. Create a directory ./provisioner/.secrets and add the GPG private key and passphase files, that you
   can find in our private repository

2. Copy the govuk-training SSH private key from our private repository to a local directory

3.1. Terraform:

  Export your AWS credentials and path to the govuk-training SSH private key. Alternatively
  you can use a Terraform variables file, or var arguments, as explained in
  https://www.terraform.io/docs/configuration/variables.html

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
  Terraform  apply .
  ```

3.2. Vagrant

  Export your AWS credentials and path to the govuk-training SSH private key

  ```
  AWS_ACCESS_KEY_ID=<aws_access_key_id>
  AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
  TRAINING_SSH_KEY_PATH=<path_to_govuk-training_ssh_key>
  ```

  At the moment we are using environment variables for the security groups and subnet ID

  ```
  export AWS_SUBNET=subnet-74dbee10
  export AWS_SECURITY_GROUPS=sg-805389f9
  ```

  Start VM

  ```
  vagrant up
  ```

