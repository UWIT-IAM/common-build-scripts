#!/usr/bin/env bash
FAILURES=
DEBUG=${DEBUG:-""}

export BUILD_SCRIPTS_DIR="${PWD}"
tests=$(find tests -name '*.sh')
source ./sources/bash-testing.sh

for test in $tests
do
  echo "==> $test <=="
  output=$(DEBUG=$DEBUG $test)
  if [[ $? -gt 0 ]]
  then
    log_failure
    echo "$output"
  else
    log_assertion_status OK
  fi
  echo
done

finalize_tests
