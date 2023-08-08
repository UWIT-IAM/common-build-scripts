#!/usr/bin/env bash

function tag_timestamp {
  # This timestamp format can be lexicographically sorted
  # which is important for flux automation.
  # This is in UTC so that timestamps will be the same,
  # whether this script is run directly from a developer's machine or from a github action
  echo $(date -u +%Y.%m.%d.%H.%M.%S)
}
