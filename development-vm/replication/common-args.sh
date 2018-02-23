#! /usr/bin/env bash
#
set -eu

. ./status_functions.sh

usage()
{
    cat <<EOF
Usage: ${USAGE_LINE:-$0 [options]}

${USAGE_DESCRIPTION-}

OPTIONS:
    -h       Show this message
    -F file  Use a custom SSH configuration file
    -u user  SSH user to log in as (overrides SSH config)
    -d dir   Use named directory to store and load backups
    -s       Skip downloading the backups (use with -d to load old backups)
    -r       Reset ignore list. This overrides any default ignores
    -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list
    -o       Don't rename databases (*_production to *_development)
    -n       Don't actually import anything (dry run)
    -m       Skip MongoDB import
    -p       Skip PostgreSQL import
    -q       Skip MySQL import
    -e       Skip Elasticsearch import
    -t       Skip Mapit import

EOF
}

DIR="backups/$(date +%Y-%m-%d)"
SKIP_DOWNLOAD=false
SKIP_MONGO=false
SKIP_POSTGRES=false
SKIP_MYSQL=false
SKIP_ELASTIC=false
SKIP_MAPIT=false
SSH_CONFIG="../ssh_config"
RENAME_DATABASES=true
DRY_RUN=false
# By default, ignore large databases which are not useful when replicated.
IGNORE="event_store transition backdrop support_contacts draft_content_store imminence"

# Test whether the given value is in the ignore list.
function ignored() {
  local value=$1
  for ignore_match in $IGNORE; do
    if [ $ignore_match == $value ]; then
      return 0
    fi
  done
  return 1
}

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
    ROLE_ARN=$(awk '/profile govuk-integration/ {profile=1} /role_arn/ && profile==1 {print $3; exit}' ~/.aws/config)
    MFA_SERIAL=$(awk '/profile govuk-integration/ {profile=1} /mfa_serial/ && profile==1 {print $3; exit}' ~/.aws/config)
    SOURCE_PROFILE=$(awk '/profile govuk-integration/ {profile=1} /source_profile/ && profile==1 {print $3; exit}' ~/.aws/config)

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

while getopts "hF:u:d:sri:onmpqet" OPTION
do
  case $OPTION in
    h )
      usage
      exit 1
      ;;
    F )
      SSH_CONFIG=$OPTARG
      ;;
    u )
      SSH_USER=$OPTARG
      ;;
    d )
      DIR=$OPTARG
      ;;
    s )
      SKIP_DOWNLOAD=true
      ;;
    r )
      IGNORE=""
      ;;
    i )
      IGNORE="$IGNORE $OPTARG"
      ;;
    o )
      RENAME_DATABASES=false
      ;;
    n )
      DRY_RUN=true
      ;;
    m )
      SKIP_MONGO=true
      ;;
    p )
      SKIP_POSTGRES=true
      ;;
    q )
      SKIP_MYSQL=true
      ;;
    e )
      SKIP_ELASTIC=true
      ;;
    t )
      SKIP_MAPIT=true
      ;;
  esac
done
