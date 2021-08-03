#!/usr/bin/env bash

source $PWD/sources/slack.sh
source $PWD/sources/bash-testing.sh

function test_slack_link {
  local test_name=test_slack_link
  echo $test_name

  set_up_assertion 'slack link matches expected output'
  assert_output_matches 'slack_link https://www.uw.edu "Husky Territory"' '<https://www.uw.edu | Husky Territory>'
}

test_slack_link
