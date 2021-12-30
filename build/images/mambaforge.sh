#!/bin/bash

set -euox pipefail

echo "${SCRIPTS_DIR}"
echo "${VERSION}"


container=$(buildah from 'docker.io/library/ubuntu:21.10')
base_image=$(buildah inspect --format '{{.FromImage}}' "${container}")
base_digest=$(buildah inspect --format '{{.FromImageDigest}}' "${container}")

buildah config --env DEBIAN_FRONTEND=noninteractive "${container}"
buildah config --env LANG=C.UTF-8 "${container}"
buildah config --env LC_ALL=C.UTF-8 "${container}"
buildah config --env TZ=Australia/Brisbane "${container}"

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

# Copy install scripts
buildah copy "${container}" "${SCRIPTS_DIR}" /tmp/mambaforge/
buildah run "${container}" -- chown -R user:user /tmp/mambaforge/
buildah run "${container}" -- ls -la /tmp/mambaforge/

# Install mambaforge
buildah run "${container}" -- bash /tmp/mambaforge/install.sh
buildah run "${container}" -- rm -rf /tmp/mambaforge

# Configure mamba
buildah copy "${container}" "${GITHUB_WORKSPACE}/build/images/docker-entrypoint.sh" /
buildah run "${container}" -- chown user:user /docker-entrypoint.sh
buildah run "${container}" -- chmod u+r+x /docker-entrypoint.sh
buildah config --entrypoint '["/docker-entrypoint.sh"]' "${container}"
buildah config --cmd '["/bin/bash"]' "${container}"
# Initialise mamba for non-interactive, non-login bash shell
buildah copy "${container}" "${GITHUB_WORKSPACE}/build/images/.bashenv" /home/user/.bashenv
buildah run "${container}" -- chown user:user /home/user/.bashenv
buildah config --env BASH_ENV=/home/user/.bashenv "${container}"

buildah run "${container}" -- ls -la /etc/profile.d

buildah config --user 'root:root' "${container}"
buildah run "${container}" -- sh -c 'echo "echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" >> /etc/profile.d/conda.sh'
# buildah run "${container}" -- sh -c 'echo "conda activate base" >> /etc/profile.d/conda.sh'
buildah config --user 'user:user' "${container}"


# image_name=`basename --suffix '.sh' "$0"`
# Doesn't work - script is copied with a random-hash name
# +++ basename --suffix .sh /home/runner/work/_temp/dcb670c3-6ff9-454d-beab-ffed99e54648.sh
# ++ image_name=dcb670c3-6ff9-454d-beab-ffed99e54648
# ++ buildah commit ubuntu-working-container dcb670c3-6ff9-454d-beab-ffed99e54648

description="Base install of the mambaforge distribution."
buildah config --label "org.opencontainers.image.description=${description}" "${container}"
buildah config --label "org.opencontainers.image.url=https://github.com/${GITHUB_REPO}" "${container}"
buildah config --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPO}/tree/${GITHUB_SHA}" "${container}"
buildah config --label "org.opencontainers.image.base.name=${base_image}" "${container}"
buildah config --label "org.opencontainers.image.base.digest=${base_digest}" "${container}"
buildah config --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%S.%3NZ')" "${container}"


buildah commit "${container}" mambaforge

buildah rm "${container}"
buildah images
buildah inspect localhost/mambaforge | jq '.Docker.config.Labels'

# https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
# org.opencontainers.image.created
# org.opencontainers.image.source = "https://github.com/energy-quants/mambaforge"
# LABEL org.opencontainers.image.description DESCRIPTION
# org.opencontainers.image.version
# org.opencontainers.image.revision Source control revision identifier for the packaged software.

# org.opencontainers.image.base.name
# org.opencontainers.image.base.digest