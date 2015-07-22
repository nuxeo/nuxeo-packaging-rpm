#!/bin/bash

cd $(dirname $0)

version=$1

if [ -z "${version}" ]; then
    echo "Usage: build-nuxeo-rpm.sh <version>"
    exit 1
fi

docker build -t nuxeo/rpmbuild .

mkdir -p cache/${version}/spec
sed "s/@VERSION@/${version}/g" templates/nuxeo.spec > cache/${version}/spec/nuxeo.spec

mkdir -p cache/${version}/zip
if [ ! -f cache/${version}/zip/nuxeo-cap-${version}-tomcat.zip ]; then
    wget -O cache/${version}/zip/nuxeo-cap-${version}-tomcat.zip http://cdn.nuxeo.com/nuxeo-${version}/nuxeo-cap-${version}-tomcat.zip
fi

if [ -d cache/${version}/rpm ]; then
    rm -rf cache/${version}/rpm
fi
mkdir -p cache/${version}/rpm

mkdir -p cache/${version}/bin
sed "s/@VERSION@/${version}/g" templates/build-nuxeo.sh > cache/${version}/bin/build.sh
chmod +x cache/${version}/bin/build.sh
cp templates/nuxeoctl cache/${version}/bin/

docker run --rm=true -v $(pwd)/cache:/cache:rw nuxeo/rpmbuild /cache/${version}/bin/build.sh

