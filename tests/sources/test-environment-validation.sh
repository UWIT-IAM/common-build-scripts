#!/usr/bin/env bash

source $PWD/sources/environment-validation.sh
source $PWD/sources/bash-testing.sh

TESTS_FAILED=

function test_assert_command {
  local test_name=test_assert_command
  echo $test_name

  set_up_assertion "expect failure when command does not exist"
  assert_failure 'assert_command foobar'

  set_up_assertion "expect success when command exists"
  assert_command bash
}

test_assert_command

finalize_tests
