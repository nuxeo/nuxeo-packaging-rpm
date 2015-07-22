Name:       ffmpeg-nuxeo
Version:    2.7.2
Release:    1
Summary:    FFmpeg packaged by Nuxeo
License:    LGPLv2.1
URL:        http://ffmpeg.org/
BuildArch:  x86_64
BuildRequires: unzip
Conflicts:  ffmpeg

%description
A complete, cross-platform solution to record, convert and stream audio and video.
This is a statically compiled version of the package provided for convenience for
users of the Nuxeo platform.


%prep


%build


%install

mkdir -p %{buildroot}/usr/bin
cp /usr/local/bin/ffmpeg %{buildroot}/usr/bin/
cp /usr/local/bin/ffprobe %{buildroot}/usr/bin/
cp /usr/local/bin/ffserver %{buildroot}/usr/bin/

%files

/usr/bin/ffmpeg
/usr/bin/ffprobe
/usr/bin/ffserver


%changelog


%pre


%post

