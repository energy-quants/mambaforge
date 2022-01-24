#!/bin/bash
set -euox pipefail

echo "######################################################################"

echo "::group::Pulling base image..."
container=$(buildah from 'docker.io/library/ubuntu:21.10')
base_image=$(buildah inspect --format '{{.FromImage}}' "${container}")
base_digest=$(buildah inspect --format '{{.FromImageDigest}}' "${container}")

buildah config --env DEBIAN_FRONTEND=noninteractive "${container}"
buildah config --env LANG=C.UTF-8 "${container}"
buildah config --env LC_ALL=C.UTF-8 "${container}"
buildah config --env TZ=Australia/Brisbane "${container}"
echo "::endgroup::"

echo "::group::Configuring OS..."
# Install required tools
buildah run "${container}" -- apt-get update
buildah run "${container}" -- apt-get install -y curl

# Create user
buildah run "${container}" -- \
    groupadd "user" \
    --gid 1000

buildah run "${container}" -- \
    useradd "user" \
    --no-log-init \
    --shell /bin/bash \
    --create-home \
    --home /home/user \
    --uid 1000 \
    --gid 1000

buildah config --env USER=user "${container}"
echo "::endgroup::"

echo "::group::Installing mambaforge..."
# Copy install scripts
buildah copy "${container}" "${GITHUB_WORKSPACE}/bootstrap/linux/mambaforge/" /tmp/mambaforge/
buildah run "${container}" -- chown -R user:user /tmp/mambaforge/
buildah run "${container}" -- ls -la /tmp/mambaforge/

# Install mambaforge
buildah run "${container}" -- bash /tmp/mambaforge/install.sh
buildah run "${container}" -- rm -rf /tmp/mambaforge
echo "::endgroup::"

echo "::group::Configuring mamba..."
# Configure entrypoint to initialise mamba
buildah copy "${container}" "$(dirname ${BASH_SOURCE})/docker-entrypoint.sh" /
buildah run "${container}" -- chown user:user /docker-entrypoint.sh
buildah run "${container}" -- chmod u+r+x /docker-entrypoint.sh
buildah config --entrypoint '["/docker-entrypoint.sh"]' "${container}"
buildah config --cmd '["/bin/bash"]' "${container}"

# Initialise mamba for non-interactive shell
buildah config --env BASH_ENV=/etc/profile "${container}"

buildah config --user 'root:root' "${container}"
# Activate `CONDA_ENV`
buildah run "${container}" -- sh -c 'echo "conda activate \"${CONDA_ENV:=base}\"" >> /etc/profile.d/conda.sh'
# For an interactive container it appears `conda.sh` needs to be run a second time
# to correctly activate the environment
buildah run "${container}" -- sh -c 'echo "source /etc/profile.d/conda.sh" >> /etc/bash.bashrc'
buildah config --user 'user:user' "${container}"
echo "::endgroup::"

echo "::group::Finalising container image..."
# Add labels
# https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
description="Base install of the mambaforge distribution."
buildah config --label "org.opencontainers.image.description=${description}" "${container}"
buildah config --label "org.opencontainers.image.url=https://github.com/${GITHUB_REPOSITORY}" "${container}"
buildah config --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_SHA}" "${container}"
buildah config --label "org.opencontainers.image.revision=${GITHUB_SHA}" "${container}"
buildah config --label "org.opencontainers.image.version=${VERSION}" "${container}"
buildah config --label "org.opencontainers.image.base.name=${base_image}" "${container}"
buildah config --label "org.opencontainers.image.base.digest=${base_digest}" "${container}"
buildah config --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%S.%3NZ')" "${container}"


buildah commit "${container}" mambaforge

buildah rm "${container}"
buildah images
buildah inspect localhost/mambaforge | jq '.Docker.config.Labels'
echo "::endgroup::"
