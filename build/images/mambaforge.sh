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

buildah run "${container}" -- groupadd "user" --gid 1000
buildah run "${container}" -- \
    useradd "user" \
    --no-log-init \
    --shell /bin/bash \
    --create-home \
    --home /home/user \
    --uid 1000 \
    --gid 1000


buildah copy "${container}" "${SCRIPTS_DIR}" '/tmp/mambaforge/'
buildah run "${container}" -- apt-get update
buildah run "${container}" -- apt-get install -y curl
buildah config --env USER=user "${container}"
#buildah run --workingdir '/tmp/mambaforge' "${container}" -- bash install.sh
buildah run "${container}" -- pushd /tmp/mambaforge && bash install.sh
buildah run "${container}" -- popd && rm -rf '/tmp/mambaforge'
#buildah config --user 'user:user' "${container}"

buildah commit "${container}" mambaforge
buildah rm "${container}"
buildah images
