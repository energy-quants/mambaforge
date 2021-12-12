GIT_DESCRIBE_VERSION=$(git describe --tags --long --dirty --always)
echo "${GIT_DESCRIBE_VERSION}"
