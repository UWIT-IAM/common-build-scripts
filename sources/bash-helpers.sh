#!/usr/bin/env bash

function tag_timestamp {
  # This timestamp format can be lexicographically sorted
  # which is important for flux automation.
  echo $(date +%Y.%m.%d.%H.%M.%S)
}
