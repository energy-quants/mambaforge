set -xo pipefail

set +eu
GIT_DESCRIBE_VERSION=$(git describe --tags --long --dirty)
set -eu

if [[ -z "${GIT_DESCRIBE_VERSION}" ]]; then
    echo "Unable to find any tags, using 0.0.0"
    MAJOR="0"
    MINOR="0"
    PATCH="0"
    SHA=$(git rev-parse --short HEAD)
    POSTN=$(printf "%03d" $(git rev-list --count HEAD))
else
    # split on dash: <semver>-<postn>-<sha>
    readarray -d '-' -t parts<<<"${GIT_DESCRIBE_VERSION}"
    SEMVER="${parts[0]}"
    POSTN=$(printf "%03d" "${parts[1]}")
    SHA="${parts[2]%%$'\n'}"  # trim trailing newline
    SHA="${SHA#g}"  # trim leading 'g'
    # split on dot: <major>.<minor>.<patch>
    readarray -d '.' -t parts<<<"${SEMVER}"
    MAJOR="${parts[0]}"
    MINOR="${parts[1]}"
    PATCH="${parts[2]%%$'\n'}"  # trim trailing newline
fi

if [[ "${POSTN}" == "000" ]]; then
    VERSION="${MAJOR}.${MINOR}.${PATCH}"
else
    VERSION="${MAJOR}.${MINOR}.${PATCH}.post${POSTN}+${SHA}"
fi
