# This collection contains functions that
# makes it easier to interact with github actions.

function set_ci_output {
  # Echoes the 'set-output' Github Actions command.
  # Use:
  #     set_ci_output my_key "Useful value"
  # CI is always true when running from a Github Actions context.
  # You can test the output by setting it in your environment.
  echo "::set-output name=$1::$2"
}

function set_env {
  local key="$1"
  local value="$2"
  echo "$key=$value" >> $GITHUB_ENV
}
