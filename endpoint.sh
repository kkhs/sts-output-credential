#!/bin/sh -e

ROLE_ARN=${1:-$ROLE_ARN}
CREDENTIAL_FILE=${CREDENTIAL_FILE:-./.aws/credentials}
INTERVAL_TIME=${INTERVAL:-1800}
DAEMON=${DAEMON:-0}
SESSION_DURATION=$((${INTERVAL_TIME}-60))

USER_NAME=$(aws sts get-caller-identity | jq -r .Arn | cut -f 2 -d "/")

while :
do
  NOW_DATE=$(date '+%Y%m%d%H%M%S')
  aws sts assume-role --role-arn $ROLE_ARN --role-session-name ${NOW_DATE}-${USER_NAME} --duration-seconds ${SESSION_DURATION} | jq .Credentials > ./assume-role.json
  STS_AWS_ACCESS_KEY_ID=$(jq -r .AccessKeyId ./assume-role.json)
  STS_AWS_SECRET_ACCESS_KEY=$(jq -r .SecretAccessKey ./assume-role.json)
  STS_AWS_SESSION_TOKEN=$(jq -r .SessionToken ./assume-role.json)

  cat << EOS > $CREDENTIAL_FILE
[default]
aws_access_key_id=${STS_AWS_ACCESS_KEY_ID}
aws_secret_access_key=${STS_AWS_SECRET_ACCESS_KEY}
aws_session_token=${STS_AWS_SESSION_TOKEN}
EOS

  if [ "$DAEMON" = "0" ]; then
    break
  fi

  echo "wait ${INTERVAL_TIME}s..."
  sleep ${INTERVAL_TIME}
done
