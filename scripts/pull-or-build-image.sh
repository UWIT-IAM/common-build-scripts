function print_help {
   cat <<EOF
   Use: pull-or-build-image.sh [--debug --help]
   Options:
   --image -i         The image repository (e.g., gcr.io/my-project/my-image:unique-tag)
   --dockerfile -d    The dockerfile used to build this image
   --force-build -f   Build the image even if it already exists.
   --push -p          Push the image when complete
   --                 Pass all remaining arguments to the 'docker build' command
   --help -h          Show this message and exit
   --debug -g         Show commands as they are executing
EOF
}

DEBUG=${DEBUG}
docker_build_args=
docker_context=.
dockerfile=Dockerfile

while (( $# ))
do
  case $1 in
    --help|-h)
      print_help
      exit 0
      ;;
    --debug|-g)
      DEBUG=1
      ;;
    --image|-i)
      shift
      image="$1"
      ;;
    --docker-context|-c)
      shift
      docker_context=$1
      ;;
    --dockerfile|-d)
      shift
      dockerfile="$1"
      ;;
    --force-build|-f)
      force_build=1
      ;;
    --push-image|-p)
      push_image=1
      ;;
    --)
      shift
      docker_build_args="$@"
      break
      ;;
    *)
      echo "Invalid Option: $1"
      print_help
      exit 1
      ;;
  esac
  shift
done

test -z "${DEBUG}" || set -x


if docker pull $image > /dev/null
then
  echo "Image already built: $image"
  test -n "${force_build}" || exit 0
fi

echo "Building image: $image"
docker build -f $dockerfile $docker_build_args -t $image $docker_context

if [[ -n "$push_image" ]]
then
  echo "Pushing image: $image"
  docker push $image
fi
