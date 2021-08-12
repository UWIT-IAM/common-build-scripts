function _create_temp_paths {
  mkdir -p $TMPDIR
  rm -rf $TMPDIR/*  # If leftover from previous test, clean it up
  echo "foo" > $TMPDIR/foo
  echo "bar" > $TMPDIR/bar
  test -z "${DEBUG}" || echo ".. created temporary files"
}

function conditional_echo {
  test -z "${DEBUG}" || echo "$1"
}

function log_assertion_status {
  conditional_echo ".. <$1> [$ASSERTION_NAME]"
}

function log_failure {
  FAILURES=$(( $FAILURES+1 ))
  DEBUG=1 log_assertion_status FAILED
}

function set_up_assertion {
  ASSERTION_NAME="$1"
  log_assertion_status STARTING
}

function assert_output_matches {
  local cmd="$1"
  local expected="$2"
  output="$(eval $cmd)"
  if [[ "$output" != "$expected" ]]
  then
    log_failure
    echo ".... expected '$expected' "
    echo ".... received '$output'"
  else
    log_assertion_status OK
  fi
}

function assert_output_matches_pattern {
  local cmd="$1"
  local expected="$2"
  output="$(eval $cmd)"
  if ! [[ "$output" =~ $expected ]]
  then
    log_failure
    echo ".... expected '$expected' "
    echo ".... received '$output'"
  else
    log_assertion_status OK
  fi
}

function assert_not_output_matches_pattern {
  local cmd="$1"
  local expected="$2"
  output="$(eval $cmd)"
  if [[ "$output" =~ $expected ]]
  then
    log_failure
    echo ".... expected not to receive output: "
    echo "...... $output"
  else
    log_assertion_status OK
  fi
}

function assert_not_output_matches {
  local cmd="$1"
  local expected="$2"
  output="$(eval $cmd)"
  if [[ "$output" == "$expected" ]]
  then
    log_failure
    echo ".... expected not to receive output: "
    echo "...... $output"
  else
    log_assertion_status OK
  fi
}

function assert_success {
  local cmd="$1"
  output="$(eval $cmd)"
  if [[ $? -gt 0 ]]
  then
    log_failure
    conditional_echo ".... output: "
    conditional_echo '"""'
    conditional_echo "$output"
    conditional_echo '"""'
  fi
}

function assert_failure {
  local cmd="$1"
  output="$(eval $cmd)"
  if [[ $? -eq 0 ]]
  then
    log_failure
    conditional_echo ".... output: "
    conditional_echo '"""'
    conditional_echo "$output"
    conditional_echo '"""'
  fi
}


function finalize_tests {
  if [[ "$FAILURES" -gt "0" ]]
  then
    echo "$FAILURES tests failed!"
    exit 1
  else
    echo "All tests succeeded!"
  fi
}
