set -xo pipefail

set +eu
GIT_DESCRIBE_VERSION=$(git describe --tags --long --dirty)
set -eu

if [[ -z "${GIT_DESCRIBE_VERSION}" ]]; then
  echo "Unable to locate tag, using 0.0.0"
  MAJOR="0"
  MINOR="0"
  PATCH="0"
  SHA=$(git rev-parse --short HEAD)
  POSTN=$(printf "%03d" $(git rev-list --count HEAD))
  if [[ "${POSTN}" == "000" ]]; then
    GIT_DESCRIBE_VERSION="${MAJOR}.${MINOR}.${PATCH}"
  else
    GIT_DESCRIBE_VERSION="${MAJOR}.${MINOR}.${PATCH}.post${POSTN}+${SHA}"
  fi
else
    readarray -d '-' -t parts<<<"${GIT_DESCRIBE_VERSION}"
    VERSION="${parts[0]}"
    POSTN=$(printf "%03d" "${parts[1]}")
    SHA="${parts[2]%$'\n'}"  # strip trailing newline
    echo "XX${SHA}XX"
    GIT_DESCRIBE_VERSION="${VERSION}.post${POSTN}+${SHA}"
fi

