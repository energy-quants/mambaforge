#!/bin/bash

set -euox pipefail

echo "${SCRIPTS_DIR}"
echo "${VERSION}"

container=$(buildah from docker.io/library/ubuntu:21.10)
echo "${container}"

buildah config --env DEBIAN_FRONTEND=noninteractive "${container}"
buildah config --env LANG=C.UTF-8 "${container}"
buildah config --env LC_ALL=C.UTF-8 "${container}"
buildah config --env TZ=Australia/Brisbane "${container}"

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


buildah run "${container}" -- apt-get update
buildah run "${container}" -- apt-get install -y curl
buildah config --env USER=user "${container}"
buildah copy "${container}" "${SCRIPTS_DIR}" /tmp/mambaforge/
buildah run "${container}" -- chown -R user:user /tmp/mambaforge/
buildah run "${container}" -- ls -la /tmp/mambaforge/
buildah run "${container}" -- bash /tmp/mambaforge/install.sh
buildah run "${container}" -- rm -rf /tmp/mambaforge
# Initialise mamba for non-interactive, non-login bash shell
buildah config --env BASH_ENV=/etc/profile.d/conda.sh "${container}"
# mamba requires a bash shell
buildah config --entrypoint '["/bin/bash", "-lc", "$0 $@"]' "${container}"

buildah run "${container}" -- ls -la /etc/profile.d
buildah run "${container}" -- echo "echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" > /etc/profile.d/conda.sh

buildah config --user 'user:user' "${container}"

# image_name=`basename --suffix '.sh' "$0"`
# Doesn't work - script is copied with a random-hash name
# +++ basename --suffix .sh /home/runner/work/_temp/dcb670c3-6ff9-454d-beab-ffed99e54648.sh
# ++ image_name=dcb670c3-6ff9-454d-beab-ffed99e54648
# ++ buildah commit ubuntu-working-container dcb670c3-6ff9-454d-beab-ffed99e54648

description="Base install of the mambaforge distribution."
buildah config --label "org.opencontainers.image.description=${description}" "${container}"
buildah config --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPO}" "${container}"

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