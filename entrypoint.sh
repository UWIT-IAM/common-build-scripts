#!/usr/bin/env bash
for src in /builder/sources/*.sh; do source $src; done
echo "Running builder command: $@"
if [[ "$1" == "test-action" ]]
then
  assert_command assert_command
else
  $@
fi
exit $?
