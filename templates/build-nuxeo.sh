#!/bin/bash

rpmdev-setuptree
cp /cache/@VERSION@/spec/nuxeo.spec /root/rpmbuild/SPECS/
rpmbuild -v -bb /root/rpmbuild/SPECS/nuxeo.spec
mv /root/rpmbuild/RPMS/noarch/nuxeo-@VERSION@-1.noarch.rpm /cache/@VERSION@/rpm/

