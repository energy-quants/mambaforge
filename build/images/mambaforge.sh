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
#buildah config --user 'user:user' "${container}"

image_name=`basename --suffix '.sh' "$0"`
buildah commit "${container}" "${image_name}"
buildah rm "${container}"
buildah images

# org.opencontainers.image.source = "https://github.com/energy-quants/mambaforge"
