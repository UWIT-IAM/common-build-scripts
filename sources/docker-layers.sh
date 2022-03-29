#!/usr/bin/env bash

function get_cached_image {
  local image_name="${1}"
  if [[ -z "$(docker images -q ${image_name})" ]]
  then
    docker pull "${image_name}" 2>/dev/null || return 1
  fi
}

function get_cached_layer {
  local layer_name="$1"
  local fingerprint="$2"
  local image_name="$(get_layer_tag ${layer_name} ${fingerprint})"
  get_cached_image "${image_name}"
}

function get_or_create_layer {
  local layer_name="$1"
  local fingerprint="$2"
  local build_args_index=3
  local force=
  if [[ "${3}" == "--force" ]]
  then
    force=1
    build_args_index=4
  fi

  if get_cached_layer "${layer_name}" "${fingerprint}"
  then
    test -n "${force}" || return 0
  fi

  local build_args="${@:$build_args_index}"
  docker build -f "${DOCKERFILE:-Dockerfile}" \
    --target "${layer_name}" \
    ${build_args} \
    -t "$(get_layer_tag ${layer_name} ${fingerprint})" .
}
