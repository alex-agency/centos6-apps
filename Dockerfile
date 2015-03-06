FROM alexagency/centos6-desktop
MAINTAINER Alex

# Variables
ENV JDKx64_ARCH  jdk-8u40-linux-x64.rpm
ENV JDKx64_URL  http://download.oracle.com/otn-pub/java/jdk/8u40-b25/$JDKx64_ARCH
ENV JDKx64_PATH  jdk1.8.0_40

ENV JDKx86_ARCH  jdk-8u40-linux-i586.tar.gz
ENV JDKx86_URL   http://download.oracle.com/otn-pub/java/jdk/8u40-b25/$JDKx86_ARCH
ENV JDKx86_PATH  jdk1.8.0_40

ENV ECLIPSE_ARCH  eclipse-java-luna-SR1a-linux-gtk.tar.gz
ENV ECLIPSE_URL  http://ftp.halifax.rwth-aachen.de/eclipse/technology/epp/downloads/release/luna/SR1a/$ECLIPSE_ARCH

ENV FIREFOX_ARCH  firefox-35.0.tar.bz2
ENV FIREFOX_URL  http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/35.0/linux-i686/en-US/$FIREFOX_ARCH

# Install dependencies
RUN yum -y update && yum -y install glibc.i686 libgcc.i686 gtk2*.i686 libXtst*.i686 alsa-lib-1.*.i686 \
dbus-glib-0.*.i686 libXt-1.*.i686 gtk2-engines gtk2-devel

# Meld diff tool
RUN yum -y update && yum -y install meld

# Sublime Text 3
RUN	wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3065_x64.tar.bz2 && \
	tar -vxjf sublime_text_3_build_3065_x64.tar.bz2 -C /usr && \
	ln -s /usr/sublime_text_3/sublime_text /usr/bin/sublime3 && \
	rm -f sublime_text_3_build_3065_x64.tar.bz2 && \
echo -e "\
[Desktop Entry]\n\
Name=Sublime 3\n\
Exec=sublime3\n\
Terminal=false\n\
Icon=/usr/sublime_text_3/Icon/48x48/sublime-text.png\n\
Type=Application\n\
Categories=TextEditor;IDE;Development\n\
X-Ayatana-Desktop-Shortcuts=NewWindow\n\
[NewWindow Shortcut Group]\n\
Name=New Window\n\
Exec=sublime -n\n\
TargetEnvironment=Unity"\
>> /usr/share/applications/sublime3.desktop && \
	mkdir /root/.config && \
	touch /root/.config/sublime-text-3 && \
	chown -R root:root /root/.config/sublime-text-3

# JDK x64
RUN wget -c --no-cookies  --no-check-certificate  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
$JDKx64_URL -O $JDKx64_ARCH && \
    rpm -i $JDKx64_ARCH && \
	rm -fv $JDKx64_ARCH && \
	echo "export JAVA_HOME=/usr/java/$JDKx64_PATH" >> /etc/bashrc && \
	echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bashrc && \
	alternatives --install /usr/bin/java java /usr/java/$JDKx64_PATH/bin/java 1 && \
	alternatives --set java /usr/java/$JDKx64_PATH/bin/java && \
	java -version
ENV JAVA_HOME /usr/java/$JDKx64_PATH
ENV JRE_HOME /usr/java/$JDKx64_PATH/jre
# Firefox 64 bit Java plugin
RUN alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 \
	/usr/java/latest/jre/lib/amd64/libnpjp2.so 200000

# Firefox 32 bit
RUN wget $FIREFOX_URL && \
	tar -vxjf $FIREFOX_ARCH -C /usr && \
	ln -s /usr/firefox/firefox /usr/bin/firefox-x86 && \
	rm -f $FIREFOX_ARCH && \
	echo -e "\
[Desktop Entry]\n\
Encoding=UTF-8\n\
Name=Firefox x86\n\
Exec=firefox-x86 %u\n\
Icon=firefox\n\
Terminal=false\n\
Type=Application\n\
Categories=Network;WebBrowser;"\
>> /usr/share/applications/firefox-x86.desktop

# JDK x86
RUN wget -c --no-cookies  --no-check-certificate  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
$JDKx86_URL && \
	mkdir -p /usr/java/x86/ && \
	tar -zxvf $JDKx86_ARCH -C /usr/java/x86/ && \
	rm -f $JDKx86_ARCH
ENV JAVA_HOME_x86  /usr/java/x86/$JDKx86_PATH
# Firefox 32 bit Java plugin
RUN alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so \
	$JAVA_HOME_x86/jre/lib/i386/libnpjp2.so 200000

# Eclipse Luna
RUN wget $ECLIPSE_URL && \
	tar -zxvf $ECLIPSE_ARCH -C /usr/ && \
	ln -s /usr/eclipse/eclipse /usr/bin/eclipse && \
	rm -f $ECLIPSE_ARCH && \
	sed -i s@-vmargs@-vm\\n$JAVA_HOME_x86/jre/bin/java\\n-vmargs@g /usr/eclipse/eclipse.ini	&& \
	echo -e "\
[Desktop Entry]\n\
Encoding=UTF-8\n\
Name=Eclipse\n\
Comment=Eclipse\n\
Exec=/usr/bin/eclipse\n\
Icon=/usr/eclipse/icon.xpm\n\
Categories=Application;Development;Java;IDE\n\
Version=1.0\n\
Type=Application\n\
Terminal=0"\
>> /usr/share/applications/eclipse.desktop

# Set environment variables
RUN echo -e "#!/bin/sh\n\
export JAVA_HOME_x86=$JAVA_HOME_x86"\ 
>> /etc/profile.d/env.sh && \
	chmod -v u+x /etc/profile.d/env.sh

# Cleanup
RUN yum clean all && rm -rf /tmp/*
