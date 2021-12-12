set -ox pipefail

GIT_DESCRIBE_VERSION=$(git describe --tags --long --dirty)

set -eu

if [ $? -ne 0 ]; then
  echo "Unable to locate tag, using 0.0.0"
  MAJOR="0"
  MINOR="0"
  PATCH="0"
  SHA=$(git rev-parse --short HEAD)
  POSTN=$(printf "%03d" $(git rev-list --count HEAD))
  if [[ "${POSTN}" == "000" ]]; then
    GIT_DESCRIBE_VERSION="${MAJOR}.${MINOR}.${PATCH}"
  else
    GIT_DESCRIBE_VERSION="${MAJOR}.${MINOR}.${PATCH}.${POSTN}+${SHA}"
  fi
fi

