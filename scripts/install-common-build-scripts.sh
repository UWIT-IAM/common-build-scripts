function print_help {
   cat <<EOF
   Use: install-common-build-scripts.sh [--debug --help]
   Options:
   -f, --force     Re-install the build scripts even if they are already present
   -d, --directory The location for your build scripts (default ./.build-scripts/)
   -v, --version   The build-scripts version you want to install (default: latest)
   +i, --no-gitignore Do not add a .gitignore entry for `.build-scripts`
   -h, --help      Show this message and exit
   -g, --debug     Show commands as they are executing
EOF
}

INSTALL_VERSION=latest
export BUILD_SCRIPTS_DIR=${BUILD_SCRIPTS_DIR:-${PWD}/.build-scripts}
GITHUB_REPO=UWIT-IAM/common-build-scripts
API_BASE=https://api.github.com/repos/${GITHUB_REPO}/releases

while (( $# ))
do
  case $1 in
    --force|-f)
      FORCE_INSTALL=1
      shift
      ;;
    --repo_version|-v)
      shift
      INSTALL_VERSION="$1"
      ;;
    --directory|-d)
      shift
      BUILD_SCRIPTS_DIR="$1"
      ;;
    --no-gitignore|+i)
      NO_GITIGNORE=1
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    --debug|-g)
      set -x
      ;;
    *)
      echo "Invalid Option: $1"
      print_help
      exit 1
      ;;
  esac
  shift
done

if [[ "${BUILD_SCRIPTS_DIR}" =~ ^\./ ]] || [[ "${PWD##"${BUILD_SCRIPTS_DIR}"}" == "${PWD}" ]]
then
  if [[ -d .git ]] && [[ -z "${NO_GITIGNORE}" ]]
  then
    grep '.build-scripts' .gitignore 2>&1 > /dev/null || echo '.build-scripts' >> .gitignore
  fi
fi


if [[ "${INSTALL_VERSION}" == 'latest' ]]
then
  api_path="$INSTALL_VERSION"
else
  api_path="tags/$INSTALL_VERSION"
fi
tarball_url=$(curl -s "${API_BASE}/${api_path}" | jq .tarball_url | sed 's|"||g')
repo_version=$(basename "${tarball_url}")


if [[ -f "${BUILD_SCRIPTS_DIR}/.VERSION" ]]
then
  installed_version=$(cat ${BUILD_SCRIPTS_DIR}/.VERSION)
  if [[ "${installed_version}" == "${repo_version}" ]] && [[ -z "${FORCE_INSTALL}" ]]
  then
    echo "Version ${repo_version} already installed, nothing to do!"
    echo "Re-run with --force to re-install."
    exit 0
  fi
fi
rm -rf "${BUILD_SCRIPTS_DIR}"

mkdir -pv $BUILD_SCRIPTS_DIR


tarball="/tmp/common-build-scripts-${repo_version}.tar.gz"

curl -Lks "${tarball_url}" --output $tarball
tarball_root=$(tar -tzf $tarball | sed -e 's@/.*@@' | uniq)
tar -xf $tarball -C /tmp
mv /tmp/$tarball_root/{sources,scripts} $BUILD_SCRIPTS_DIR
echo "${repo_version}" >> ${BUILD_SCRIPTS_DIR}/.VERSION
rm -rf /tmp/${tarball_root}

echo "Installed uwit-iam/common-build-scripts version ${repo_version} to ${BUILD_SCRIPTS_DIR}"
