FROM alex/centos6:desktop
MAINTAINER Alex

# Variables
ENV JDKx64_ARCH  jdk-8u25-linux-x64.rpm
ENV JDKx64_URL  http://download.oracle.com/otn-pub/java/jdk/8u25-b17/$JDKx64_ARCH
ENV JDKx64_PATH  jdk1.8.0_25

ENV JDKi586_ARCH  jdk-8u25-linux-i586.tar.gz
ENV JDKi586_URL   http://download.oracle.com/otn-pub/java/jdk/8u25-b17/$JDKi586_ARCH
ENV JDKi586_PATH  jdk1.8.0_25

ENV ECLIPSE_ARCH  eclipse-java-luna-SR1-linux-gtk.tar.gz
ENV ECLIPSE_URL  http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/luna/SR1/$ECLIPSE_ARCH

# Update
RUN yum clean all; yum -y update

# Install dependencies
RUN yum -y install glibc.i686 libgcc.i686 gtk2*.i686 libXtst*.i686

# Meld diff tool
RUN yum -y install meld

# Sublime Text 3
RUN	wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3065_x64.tar.bz2 && \
	tar -vxjf sublime_text_3_build_3065_x64.tar.bz2 -C /opt && \
	ln -s /opt/sublime_text_3/sublime_text /usr/bin/sublime3 && \
	rm -f sublime_text_3_build_3065_x64.tar.bz2 && \
echo -e "[Desktop Entry]\nName=Sublime 3\nExec=sublime3\nTerminal=false\n\
Icon=/opt/sublime_text_3/Icon/48x48/sublime-text.png\nType=Application\n\
Categories=TextEditor;IDE;Development\nX-Ayatana-Desktop-Shortcuts=NewWindow\n\n\
[NewWindow Shortcut Group]\nName=New Window\nExec=sublime -n\nTargetEnvironment=Unity"\
>> /usr/share/applications/sublime3.desktop && \
	mkdir /root/.config && \
	touch /root/.config/sublime-text-3 && \
	chown -R root:root /root/.config/sublime-text-3

# JDK x64 1.8.0_25
RUN wget -c --no-cookies  --no-check-certificate  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
$JDKx64_URL  -O /tmp/$JDKx64_ARCH  && \
	rpm -i /tmp/$JDKx64_ARCH && rm -fv /tmp/$JDKx64_ARCH && \
	echo "export JAVA_HOME=/usr/java/$JDKx64_PATH" >> /etc/bashrc && \
	echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bashrc && \
	alternatives   --install /usr/bin/java java /usr/java/$JDKx64_PATH/bin/java 1 && \
	alternatives   --set  java  /usr/java/$JDKx64_PATH/bin/java && \
	java -version
ENV JAVA_HOME /usr/java/$JDKx64_PATH
ENV	JRE_HOME /usr/java/$JDKx64_PATH/jre
# Firefox Java plugin
RUN alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 \
	/usr/java/latest/jre/lib/amd64/libnpjp2.so 200000

# JDK i586 1.8.0_25
RUN wget -c --no-cookies  --no-check-certificate  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
$JDKi586_URL && \
	mkdir -p /usr/java/i586/ && \
	tar -zxvf $JDKi586_ARCH -C /usr/java/i586/ && \
	rm -f $JDKi586_ARCH
ENV JAVAi586_HOME  /usr/java/i586/$JDKi586_PATH
ENV JREi586_HOME  /usr/java/i586/$JDKi586_PATH/jre
ENV JAVAi586_EXEC  $JAVAi586_HOME/bin/java

# Eclipse Luna
RUN	wget $ECLIPSE_URL && \
	tar -zxvf $ECLIPSE_ARCH -C /usr/ && \
	ln -s /usr/eclipse/eclipse /usr/bin/eclipse && \
	rm -f $ECLIPSE_ARCH
RUN \
	sed -i s@-vmargs@-vm\\n$JAVAi586_EXEC\\n-vmargs@g /usr/eclipse/eclipse.ini	
RUN \
	echo -e "[Desktop Entry]\nEncoding=UTF-8\nName=Eclipse 4.4.1\nComment=Eclipse Luna\n\
Exec=/usr/bin/eclipse\nIcon=/usr/eclipse/icon.xpm\nCategories=Application;Development;Java;IDE\n\
Version=1.0\nType=Application\nTerminal=0"\
>> /usr/share/applications/eclipse-4.4.desktop

# Chrome
RUN	wget http://chrome.richardlloyd.org.uk/install_chrome.sh && \
	chmod -v u+x install_chrome.sh; ./install_chrome.sh -f && \
	rm -f install_chrome.sh; rm -rf /root/rpmbuild

# Cleanup
RUN yum clean all; rm -rf /tmp/* /var/log/*

