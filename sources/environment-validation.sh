# This collection contains functions that
# validate the state of a build environment.

function assert_command {
  # Asserts the command is found on the current PATH.
  # Can accept an optional message to guide users.
  # Use:
  #   assert_command cmd_name "Run bar to install cmd_name"
  if ! type "$1" 2>&1 >/dev/null
  then
    echo "$1 not found on your current PATH."
    test -n "$2" && echo "$2"
    echo
    exit 1
  fi
}
