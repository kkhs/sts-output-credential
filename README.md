# sts-output-credential

sts-output-credential is output aws credential tool.

Run `aws sts assume-role` and create ``.aws/credentials`

## Use

Run and confirm example dir.

`$ ls -al example`

### Oneshot
```
$ docker run \
  -v `pwd`/data:/workspace/.aws \
  -e AWS_ACCESS_KEY_ID=[YOUR ACCESS KEY] \
  -e AWS_SECRET_ACCESS_KEY=[YOUR SECRET ACCESS KEY] \
  kkhs/sts-output-credential \
  [YOUR ROLE ARN]
```

### Daemon

```
$ docker run \
  -v `pwd`/data:/workspace/.aws \
  -e AWS_ACCESS_KEY_ID=[YOUR ACCESS KEY] \
  -e AWS_SECRET_ACCESS_KEY=[YOUR SECRET ACCESS KEY] \
  -e DAEMON=1 \
  kkhs/sts-output-credential \
  [YOUR ROLE ARN]
```

### Environment Role ARN

```
$ docker run \
  -v `pwd`/data:/workspace/.aws \
  -e AWS_ACCESS_KEY_ID=[YOUR ACCESS KEY] \
  -e AWS_SECRET_ACCESS_KEY=[YOUR SECRET ACCESS KEY] \
  -e ROLE_ARN=[YOUR ROLE ARN] \
  kkhs/sts-output-credential
```

## Environment

- ROLE_ARN: Require
  - The first argument or Set Environment variable.
- CREDENTIAL_FILE: Option
  - Write credential keys file (Default ./.aws/credentials)
- DAEMON: Option
  - Daemon mode flag. (Default 0)
- INTERVAL_TIME: Option
  - Daemon mode option. Run sts command Interval. (Default 1800)

## Use Case

Share credential data on docker-compose.

docker-compose.yml
```
version: "3"
volumes:
  aws-credential:
services:
  sts-output-credential:
    build: .
    env_file:
      - ./config/aws.env
    environment:
      - DAEMON=1
      - ROLE_ARN=[YOUR ROLE ARN]
    volumes:
      - aws-credential:/workspace/.aws
  aws-cli:
    image: mesosphere/aws-cli
    volumes:
      - aws-credential:/root/.aws
```

```
$ docker-compose up -d sts-output-credential
$ docker-compose aws-cli s3 ls
```
