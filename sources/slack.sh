# This collection contains functions that
# make it easier to format data for a slack
# notification

function slack_link {
  # Generates a 'mrkdwn' link.
  # Use:
  #   slack_link https://www.uw.edu "University of Washington"
  local url="$1"
  local link_text="$2"
  echo "<$url | $link_text>"
}
