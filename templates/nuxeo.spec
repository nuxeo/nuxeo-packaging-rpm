Name:       nuxeo
Version:    @VERSION@
Release:    1
Summary:    Full-featured document management server and platform
License:    LGPLv2.1
URL:        http://www.nuxeo.com/
BuildArch:  noarch
BuildRequires: unzip
Requires:   java-1.8.0-openjdk

%description
Nuxeo is a document management server, designed to help organizations
better manage their digital content (documents, images, videos, etc.). It
provides an approachable and cost effective alternative to mainstream
proprietary, resource-intensive offerings for document management.

Its main features include: metadata/taxonomies, versioning, lifecyle
management, workflow, relations, searching, reporting, transformation,
auditing, retention and content automation.

Nuxeo is already used by many large companies and public sector
organizations to manage up to hundreds of millions of documents.

Its graphical interface is web-based, allowing user to work with just a simple
web browser. Various APIs, including web services and REST APIs, allow
developers and systems integrators to use the Nuxeo platform to build vertical
business application for their own customers needs.

Thanks to its plugin system, it can be extended with additional technical and
business features.

You can find more information about Nuxeo at http://www.nuxeo.com/


%define nuxeobase /opt/nuxeo


%prep


%build


%install

%define __jar_repack %{nil}

useradd nuxeo
unzip -q /cache/%{version}/zip/nuxeo-cap-%{version}-tomcat.zip

rm -rf %{buildroot}
mkdir -m 0755 -p %{buildroot}/usr/bin
mkdir -m 0700 -p %{buildroot}%{nuxeobase}

mkdir -m 0700 -p %{buildroot}%{nuxeobase}/conf
mv nuxeo-cap-%{version}-tomcat/bin/nuxeo.conf %{buildroot}%{nuxeobase}/conf/

mv nuxeo-cap-%{version}-tomcat %{buildroot}%{nuxeobase}/server
rm -f %{buildroot}%{nuxeobase}/server/bin/*.bat

mkdir -m 0700 -p %{buildroot}%{nuxeobase}/log
mkdir -m 0700 -p %{buildroot}%{nuxeobase}/tmp

cp /cache/%{version}/bin/nuxeoctl %{buildroot}/usr/bin/
chmod 0755 %{buildroot}/usr/bin/nuxeoctl

%files

%defattr(-, nuxeo, nuxeo, -)
%dir %{nuxeobase}
%dir %{nuxeobase}/conf
%dir %{nuxeobase}/log
%dir %{nuxeobase}/tmp
%config(noreplace) %{nuxeobase}/conf/nuxeo.conf
%{nuxeobase}/server

%defattr(-, root, root, -)
/usr/bin/nuxeoctl


%changelog


%pre

if [ -d %{nuxeobase}/server ]; then
    nuxeoctl mp-list | grep -i -E "(started|starting|installing|downloaded)" > /tmp/nuxeo.pkglist
    nuxeoctl mp-purge
    # Cleanup old version
    rm -rf %{nuxeobase}/server
else
    useradd nuxeo
fi


%post

# First install
if [ ! -f /etc/nuxeo ]; then
    ln -s %{nuxeobase}/conf /etc/nuxeo
    ln -s %{nuxeobase}/log /var/log/nuxeo
    sed -i -e "/nuxeo\.data\.dir=/d" %{nuxeobase}/conf/nuxeo.conf
    sed -i -e "/nuxeo\.log\.dir=/d" %{nuxeobase}/conf/nuxeo.conf
    sed -i -e "/nuxeo\.pid\.dir=/d" %{nuxeobase}/conf/nuxeo.conf
    sed -i -e "/nuxeo\.tmp\.dir=/d" %{nuxeobase}/conf/nuxeo.conf
    echo "nuxeo.data.dir=%{nuxeobase}/data" >> %{nuxeobase}/conf/nuxeo.conf
    echo "nuxeo.log.dir=%{nuxeobase}/log" >> %{nuxeobase}/conf/nuxeo.conf
    echo "nuxeo.tmp.dir=%{nuxeobase}/tmp" >> %{nuxeobase}/conf/nuxeo.conf
    echo "nuxeo.pid.dir=%{nuxeobase}/tmp" >> %{nuxeobase}/conf/nuxeo.conf
fi

if [ -f /tmp/nuxeo.pkglist ]; then
    oldpkglist=$(cat /tmp/nuxeo.pkglist | grep -v -- '-HF' | grep -i -E "(started|starting|installing)" | awk '{print $3}' | tr '\n' ' ')
    if [ -n "$oldpkglist" ]; then
        nuxeoctl mp-set --relax=false --accept=true --ignore-missing $oldpkglist
    fi
    rm /tmp/nuxeo.pkglist
fi

