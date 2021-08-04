source $PWD/sources/github.sh
source $PWD/sources/bash-testing.sh

function test_get_tag_archive {
  local test_name=test_get_tag_archive
  echo $test_name
  test -z "${NO_REMOTE}" || return 0
  rm -rf /tmp/build-scripts
  set_up_assertion 'can download the latest build'
  cmd='get_tag_archive UWIT-IAM/common-build-scripts'
  assert_success "$cmd"
  assert_success "test -f /tmp/build-scripts/sources/environment-validation.sh"

  rm -rf /tmp/build-scripts
  set_up_assertion 'can download a specific build'
  cmd='get_tag_archive UWIT-IAM/common-build-scripts 0.0.2'
  assert_success "$cmd"
  assert_success "test -f /tmp/build-scripts/sources/environment-validation.sh"

  rm -rf /tmp/build-scripts
  rm -rf /tmp/alt-build-scripts
  set_up_assertion 'can download to an alternate location'
  cmd='get_tag_archive UWIT-IAM/common-build-scripts latest /tmp/alt-build-scripts'
  assert_success "$cmd"
  assert_success "test -f /tmp/alt-build-scripts/sources/environment-validation.sh"
  rm -rf /tmp/build-scripts
  rm -rf /tmp/alt-build-scripts
}

test_get_tag_archive
finalize_tests
