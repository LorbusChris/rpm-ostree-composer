#!/bin/bash -x

mkdir /srv/build/build-repo
ostree --repo=/srv/build/build-repo init --mode=bare-user
rpm-ostree compose tree --cachedir=/srv/build/cache --repo=/srv/build/build-repo /srv/src/host.json
ostree --repo=/srv/build/repo pull-local /srv/build/build-repo
ostree --repo=/srv/build/repo summary -u
rm -rf /srv/build/build-repo