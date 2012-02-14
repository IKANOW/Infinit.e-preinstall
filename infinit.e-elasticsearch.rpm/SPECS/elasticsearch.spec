%define debug_package %{nil}

%define __os_install_post    \
%{nil}
# THIS DOESN'T WORK WITH BAMBOO INSTALL:
#%define __os_install_post    \
#    /usr/lib/rpm/redhat/brp-compress \
#    %{!?__debug_package:/usr/lib/rpm/redhat/brp-strip %{__strip}} \
#    /usr/lib/rpm/redhat/brp-strip-static-archive %{__strip} \
#    /usr/lib/rpm/redhat/brp-strip-comment-note %{__strip} %{__objdump} \
#    /usr/lib/rpm/brp-python-bytecompile \
#%{nil}

#ACP: this started off life as 'https://github.com/tavisto/elasticsearch-rpms/blob/master/SPECS/elasticsearch.spec'
#     but it's been edited a fair bit.

Name:           elasticsearch
Version:        0.18.7
Release:        1
Summary:        A distributed, highly available, RESTful search engine
BuildArch:      noarch

Group:          System Environment/Daemons
License:        ASL 2.0
URL:            http://www.elasticsearch.com
Source0:        https://github.com/downloads/%{name}/%{name}/%{name}-%{version}.tar.gz
Source1:        init.d-elasticsearch
Source2:        logrotate.d-elasticsearch
Source3:        config-logging.yml
Source4:        sysconfig-elasticsearch
#ACP (Remove some unused sources)
Source9:        http://elasticsearch.googlecode.com/svn/plugins/lang-javascript/elasticsearch-lang-javascript-%{version}.zip
#ACP (Add some new sources:)
Source10:		elasticsearch-plugins-bigdesk.tar.gz
Source11:		elasticsearch-plugins-head.tar.gz
 
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       jpackage-utils
Requires:       java

Requires(post): chkconfig initscripts
Requires(pre):  chkconfig initscripts
Requires(pre):  shadow-utils

%description
A distributed, highly available, RESTful search engine

%prep
%setup -q -n %{name}-%{version}
unzip %{SOURCE9}

%build
true

%install

%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 755 bin/elasticsearch %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 644 bin/elasticsearch.in.sh %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 755 bin/plugin %{buildroot}%{_javadir}/%{name}/bin

#libs
%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/lib/sigar
%{__install} -p -m 644 lib/*.jar %{buildroot}%{_javadir}/%{name}/lib
%{__install} -p -m 644 lib/sigar/*.jar %{buildroot}%{_javadir}/%{name}/lib/sigar
%ifarch i386
%{__install} -p -m 644 lib/sigar/libsigar-x86-linux.so %{buildroot}%{_javadir}/%{name}/lib/sigar
%endif
%ifarch x86_64
%{__install} -p -m 644 lib/sigar/libsigar-amd64-linux.so %{buildroot}%{_javadir}/%{name}/lib/sigar
%endif

# config
%{__mkdir} -p %{buildroot}%{_sysconfdir}/elasticsearch
%{__install} -m 644 config/elasticsearch.yml %{buildroot}%{_sysconfdir}/%{name}
%{__install} -m 644 %{SOURCE3} %{buildroot}%{_sysconfdir}/%{name}/logging.yml

# data
%{__mkdir} -p %{buildroot}%{_localstatedir}/lib/%{name}

# logs
%{__mkdir} -p %{buildroot}%{_localstatedir}/log/%{name}
%{__install} -D -m 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/logrotate.d/elasticsearch

# plugins
%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/plugins
##########TODO

# sysconfig and init
%{__mkdir} -p %{buildroot}%{_sysconfdir}/rc.d/init.d
%{__mkdir} -p %{buildroot}%{_sysconfdir}/sysconfig
%{__install} -m 755 %{SOURCE1} %{buildroot}%{_sysconfdir}/rc.d/init.d/elasticsearch
%{__install} -m 755 %{SOURCE4} %{buildroot}%{_sysconfdir}/sysconfig/elasticsearch

%{__mkdir} -p %{buildroot}%{_localstatedir}/run/elasticsearch
%{__mkdir} -p %{buildroot}%{_localstatedir}/lock/subsys/elasticsearch

#ACP (removed unused plugins)

# plugin-lang-javascript (includes js jars)
%{__install} -D -m 755 elasticsearch-lang-javascript-%{version}.jar %{buildroot}%{_javadir}/%{name}/plugins/lang-javascript/elasticsearch-lang-javascript.jar
%{__install} -D -m 755 rhino*.jar %{buildroot}%{_javadir}/%{name}/plugins/lang-javascript/rhino.jar

#ACP (add new plugins)
zcat %{SOURCE10} | tar -xvf - -C %{buildroot}%{_javadir}/%{name}/plugins
zcat %{SOURCE11} | tar -xvf - -C %{buildroot}%{_javadir}/%{name}/plugins

# Uninstall old files here so they don't get checked
cd ..
rm -rf $RPM_BUILD_ROOT/elasticsearch-%{version}/

%pre
# create elasticsearch group
if ! getent group elasticsearch >/dev/null; then
        groupadd -r elasticsearch
fi

# create elasticsearch user
if ! getent passwd elasticsearch >/dev/null; then
        useradd -r -g elasticsearch -d %{_javadir}/%{name} \
            -s /sbin/nologin -c "You know, for search" elasticsearch
fi

%post
/sbin/chkconfig --add elasticsearch

%preun
if [ $1 -eq 0 ]; then
  /sbin/service elasticsearch stop >/dev/null 2>&1
  /sbin/chkconfig --del elasticsearch
fi

#ACP (removed %clean section, didn't seem to work)

%files
%defattr(-,root,root,-)
%{_sysconfdir}/rc.d/init.d/elasticsearch
%config(noreplace) %{_sysconfdir}/sysconfig/elasticsearch
%{_sysconfdir}/logrotate.d/elasticsearch
%dir %{_javadir}/elasticsearch
%{_javadir}/elasticsearch/bin/*
%{_javadir}/elasticsearch/lib/*
%dir %{_javadir}/elasticsearch/plugins
%config(noreplace) %{_sysconfdir}/elasticsearch
#ACP: Commented out next line to get spec file to work
#%doc LICENSE.txt  NOTICE.txt  README.textile
%defattr(-,elasticsearch,elasticsearch,-)
%dir %{_localstatedir}/lib/elasticsearch
%{_localstatedir}/run/elasticsearch
%dir %{_localstatedir}/log/elasticsearch

#ACP (removed unused plugins)

%dir %{_javadir}/elasticsearch/plugins/lang-javascript
%{_javadir}/elasticsearch/plugins/lang-javascript/*

#ACP (add new plugins)

%dir %{_javadir}/elasticsearch/plugins/bigdesk
%{_javadir}/elasticsearch/plugins/bigdesk/*

%dir %{_javadir}/elasticsearch/plugins/head
%{_javadir}/elasticsearch/plugins/head/*

#ACP: (removed changelog - file has changed sufficiently I didn't want to cause confusion)
