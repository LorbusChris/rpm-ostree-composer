#!/bin/bash -x

ctr1=`buildah from docker.io/library/fedora:rawhide`

buildah config --workingdir /srv/src/ $ctr1
# Get all updates and install build tooling
buildah run $ctr1 -- dnf update -y
buildah run $ctr1 -- dnf install -y rpm-ostree make createrepo_c dnf-utils
# Build rpm-ostree from source
buildah copy $ctr1 build-rpm-ostree.sh
buildah run $ctr1 -- bash ./build-rpm-ostree.sh
buildah run $ctr1 -- rm -f ./build-rpm-ostree.sh
buildah run $ctr1 -- dnf clean all
# Init ostree repos
buildah run $ctr1 -- mkdir -p /srv/build/cache /srv/build/repo
buildah run $ctr1 -- ostree --repo=/srv/build/repo init --mode=archive
buildah copy $ctr1 compose.sh /run/compose.sh
buildah config --cmd /run/compose.sh $ctr1
# Commit this container to an image name
buildah commit $ctr1 localhost/$USER/ostree-composer