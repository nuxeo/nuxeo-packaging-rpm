#!/bin/bash

cd $(dirname $0)

mkdir -p cache/ffmpeg/spec
cp templates/ffmpeg-nuxeo.spec cache/ffmpeg/spec/ffmpeg-nuxeo.spec

if [ -d cache/ffmpeg/rpm ]; then
    rm -rf cache/ffmpeg/rpm
fi
mkdir -p cache/ffmpeg/rpm

mkdir -p cache/ffmpeg/bin
cp templates/build-ffmpeg.sh cache/ffmpeg/bin/build.sh
chmod +x cache/ffmpeg/bin/build.sh

docker run --rm=true -v $(pwd)/cache:/cache:rw centos:centos7 /cache/ffmpeg/bin/build.sh

