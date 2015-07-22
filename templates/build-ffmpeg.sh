#!/bin/bash -e

yum -y install rpmdevtools rpmlint unzip

yum -y install wget tar bzip2 glibc gcc gcc-c++ autoconf automake libtool make nasm pkgconfig git
yum -y install glibc-static SDL-devel alsa-lib-devel freetype-devel giflib gsm gsm-devel
yum -y install libICE-devel libSM-devel libX11-devel libXau-devel libXdmcp-devel libXext-devel
yum -y install libXrandr-devel libXrender-devel libXt-devel xorg-x11-proto-devel
yum -y install libogg libvorbis vorbis-tools mesa-libGL-devel mesa-libGLU-devel zlib-devel
yum -y install libtheora theora-tools ncurses-devel libdc1394 libdc1394-devel

mkdir -p /usr/local/src

cd /usr/local/src
wget http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz
tar xzf xvidcore-1.3.2.tar.gz
cd xvidcore/build/generic
./configure --prefix="/usr/local/src/ffmpeg_build"
make
make install

cd /usr/local/src
wget http://downloads.sourceforge.net/opencore-amr/vo-aacenc-0.1.2.tar.gz
tar xzf vo-aacenc-0.1.2.tar.gz
cd vo-aacenc-0.1.2
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-shared
make
make install

cd /usr/local/src
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="/usr/local/src/ffmpeg_build" --bindir="/usr/local/src/bin"
make
make install
export PATH=/usr/local/src/bin:$PATH

cd /usr/local/src
git clone https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
git checkout tags/v1.3.0
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-examples
make
make install

cd /usr/local/src
git clone git://git.videolan.org/x264.git
cd x264
git checkout stable
./configure --prefix="/usr/local/src/ffmpeg_build" --bindir="/usr/local/src/bin" --enable-static
make
make install

cd /usr/local/src
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-shared
make
make install

cd /usr/local/src
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="/usr/local/src/ffmpeg_build" --with-ogg="/usr/local/src/ffmpeg_build" --disable-shared
make
make install

cd /usr/local/src
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="/usr/local/src/ffmpeg_build" --with-ogg="/usr/local/src/ffmpeg_build" --disable-examples --disable-shared --disable-sdltest --disable-vorbistest
make
make install

cd /usr/local/src
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="/usr/local/src/ffmpeg_build"
make
make install

cd /usr/local/src
wget http://www.ffmpeg.org/releases/ffmpeg-2.7.2.tar.bz2
tar xjf ffmpeg-2.7.2.tar.bz2
cd ffmpeg-2.7.2
PKG_CONFIG_PATH="/usr/local/src/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --extra-cflags="-I/usr/local/src/ffmpeg_build/include --static" \
--extra-ldflags="-L/usr/local/src/ffmpeg_build/lib" \
--extra-libs="-ldl -static" --enable-version3 --enable-libvpx \
--enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 \
--enable-libvo-aacenc --enable-libxvid --disable-ffplay \
--enable-gpl --enable-postproc --enable-avfilter \
--enable-pthreads --enable-static --disable-shared
make
make install

rpmbuild -bb /cache/ffmpeg/spec/ffmpeg-nuxeo.spec
cp /root/rpmbuild/RPMS/x86_64/ffmpeg-nuxeo-2.7.2-1.x86_64.rpm /cache/ffmpeg/rpm/

