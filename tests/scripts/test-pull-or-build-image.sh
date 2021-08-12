#!/usr/bin/env bash

source $PWD/sources/bash-testing.sh
script_name=pull-or-build-image.sh
existing_image="ghcr.io/uwit-iam/common-build-scripts:release"
new_image="ghcr.io/uwit-iam/common-build-scripts:codswallop"

function test_image_already_exists {
  local test_name='test_image_already_exists'
  echo $test_name
  local cmd="$PWD/scripts/$script_name -i $existing_image -d Dockerfile"
  set_up_assertion 'when image already exists, it is not re-built'
  assert_output_matches_pattern "$cmd" "Image already built: $existing_image"
  assert_not_output_matches_pattern "$cmd" "Building image: $existing_image"
}

function test_image_already_exists_force_rebuild {
  local test_name='test_image_already_exists_force_rebuild'
  echo $test_name
  local cmd="$PWD/scripts/$script_name -i $existing_image -d Dockerfile --force-build"
  set_up_assertion 'when image already exists and --force-build is set, it is re-built'
  assert_output_matches_pattern "$cmd" "Image already built: $existing_image"
  assert_output_matches_pattern "$cmd" "Building image: $existing_image"
}

function test_image_does_not_exist_builds {
  local test_name='test_image_does_not_exist_builds'
  echo $test_name
  local cmd="$PWD/scripts/$script_name -i $new_image -d Dockerfile"
  set_up_assertion 'when image does not exist, it is built'
  assert_output_matches_pattern "$cmd" "Building image: $new_image"
  docker rmi $new_image >/dev/null
}

test_image_already_exists
test_image_already_exists_force_rebuild
test_image_does_not_exist_builds
finalize_tests
