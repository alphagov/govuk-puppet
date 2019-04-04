aws_auth() {
  temporary_aws_credentials=$(dirname $0)/.temporary_aws_credentials
  test -f ${temporary_aws_credentials} && source ${temporary_aws_credentials}

  if [ -z "${AWS_ACCESS_KEY_ID-}" ] || \
    [ -z "${AWS_SECRET_ACCESS_KEY-}" ] || \
    [ -z "${AWS_SESSION_TOKEN-}" ] || \
    [ -z "${AWS_EXPIRATION-}" ] || \
    [ $(ruby -r time -e 'puts (Time.parse(ENV["AWS_EXPIRATION"]) - Time.now).floor') -lt 300 ]; then

    # setup AWS access
    SESSION_NAME=$(whoami)-$(date +%d-%m-%y_%H-%M)
    ROLE_ARN=$(awk '/profile govuk-infrastructure-integration/ {profile=1} /role_arn/ && profile==1 {print $3; exit}' ~/.aws/config)
    MFA_SERIAL=$(awk '/profile govuk-infrastructure-integration/ {profile=1} /mfa_serial/ && profile==1 {print $3; exit}' ~/.aws/config)
    SOURCE_PROFILE=$(awk '/profile govuk-infrastructure-integration/ {profile=1} /source_profile/ && profile==1 {print $3; exit}' ~/.aws/config)

    unset AWS_SESSION_TOKEN

    prompt='Enter MFA token: '
    if [ ! -z "${AWS_EXPIRATION-}" ]; then
      prompt="Your AWS session has expired. ${prompt}"
    fi
    read -p "${prompt}" MFA_TOKEN

    aws_assume_role="aws sts assume-role \
                    --profile $SOURCE_PROFILE \
                    --role-session-name $SESSION_NAME \
                    --role-arn $ROLE_ARN \
                    --serial-number $MFA_SERIAL \
                    --duration-seconds 28800 \
                    --token-code $MFA_TOKEN"

    CREDENTIALS=$(${aws_assume_role})

    if [[ $? == 0 ]]; then
      ACCESS_KEY_ID=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["AccessKeyId"]')
      export AWS_ACCESS_KEY_ID=${ACCESS_KEY_ID}
      SECRET_ACCESS_KEY=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["SecretAccessKey"]')
      export AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
      SESSION_TOKEN=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["SessionToken"]')
      export AWS_SESSION_TOKEN=${SESSION_TOKEN}
      EXPIRATION=$(echo ${CREDENTIALS} | ruby -e 'require "json"; c = JSON.parse(STDIN.read)["Credentials"]; STDOUT << c["Expiration"]')
      export AWS_EXPIRATION=${EXPIRATION}

      status "Logging in with AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"

      echo "export AWS_ACCESS_KEY_ID=${ACCESS_KEY_ID}" > ${temporary_aws_credentials}
      echo "export AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}" >> ${temporary_aws_credentials}
      echo "export AWS_SESSION_TOKEN=${SESSION_TOKEN}" >> ${temporary_aws_credentials}
      echo "export AWS_EXPIRATION=${EXPIRATION}" >> ${temporary_aws_credentials}
    else
      exit "Unable to get AWS access"
    fi
  fi
}
