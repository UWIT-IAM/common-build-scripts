#!/usr/bin/env bash

source $PWD/sources/github-actions.sh
source $PWD/sources/bash-testing.sh

FAILURES=0

function test_set_ci_output {
  local test_name='test_set_ci_output'
  echo $test_name
  local cmd="set_ci_output key-name 'value string'"
  set_up_assertion 'set-output command is echoed as expected'
  assert_output_matches "$cmd" "::set-output name=key-name::value string"
}

test_set_ci_output

finalize_tests
