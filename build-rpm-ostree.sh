#!/bin/bash -x

rpm -qa --queryformat='%{NAME}\n' | sort -u > rpms.txt
dnf builddep -y rpm-ostree
git clone https://github.com/projectatomic/rpm-ostree
cd rpm-ostree
# Note --enable-rust
./autogen.sh --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --enable-rust
make -j 8
make install
cd ..
rm rpm-ostree -rf
rpm -qa --queryformat='%{NAME}\n' | sort -u > rpms-new.txt
# Pretty awesome hack to remove the BuildRequires
comm -1 -3 rpms{,-new}.txt | xargs -r dnf -y remove