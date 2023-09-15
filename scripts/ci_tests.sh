#!/bin/bash
#
# Name::        ci_tests.sh
# Description:: Use this script to run ci tests of this repository
# Author::      Salim Afiune Maya (<afiune@lacework.net>)
#
set -eou pipefail

readonly project_name=terraform-aws-cloudtrail-controltower

TEST_CASES=(
  examples/default
)

log() {
  echo "--> ${project_name}: $1"
}

warn() {
  echo "xxx ${project_name}: $1" >&2
}

write_aws_profiles() {
  log "Writing AWS profiles"
  if [ ! -d "~/.aws" ]; then
    mkdir ~/.aws
    echo "[918733600796_AWSAdministratorAccess]" > ~/.aws/credentials
    echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    echo "aws_session_token = $AWS_SESSION_TOKEN" >> ~/.aws/credentials
    echo "[287453222145_AWSAdministratorAccess]" >> ~/.aws/credentials
    echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    echo "aws_session_token = $AWS_SESSION_TOKEN" >> ~/.aws/credentials
    chmod 600 ~/.aws/credentials
  fi
}

integration_tests() {
  for tcase in ${TEST_CASES[*]}; do
    log "Running tests at $tcase"
    ( cd $tcase || exit 1
      terraform init
      terraform validate
      terraform plan
    ) || exit 1
  done
}

lint_tests() {
  log "terraform fmt check"
  terraform fmt -check
}

main() {
  write_aws_profiles
  lint_tests
  integration_tests
}

main || exit 99
