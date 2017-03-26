#!/bin/bash

#resolve_vnc_connection
VNC_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
VNC_PORT="590"${DISPLAY:1}

##change vnc password
echo "change vnc password!"
(echo $VNC_PW && echo $VNC_PW) | vncpasswd

##start vncserver and noVNC webclient

vncserver -kill :1 && rm -rfv /tmp/.X* ; echo "remove old vnc locks to be a reattachable container"
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION
sleep 1
##log connect options
echo -e "\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"

if [ $INSTALL == "netbeans" ]; then
apt-get install -y wget
apt-get install software-properties-common -y
apt-get install -y openjdk-7-jre openjdk-7-jdk
add-apt-repository -y ppa:vajdics/netbeans-installer
apt-get update
apt-get install unzip -y
apt-get install netbeans-installer -y
mkdir /root/.netbeans /root/.netbeans/8.1 /root/.netbeans/8.1/var
touch /root/.netbeans/8.1/var/license_accepted
/opt/netbeans/bin/netbeans

#elif [ $INSTALL == "chrome" ]; then
#apt-get install -y wget
#wget https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /src/google-talkplugin_current_amd64.deb
#apt-get update && apt-get install -y \
#apt-transport-https \
#ca-certificates \
#curl \
#gnupg \
#hicolor-icon-theme \
#libgl1-mesa-dri \
#libgl1-mesa-glx \
#libpulse0 \
#libv4l-0 \
#fonts-symbola \
#--no-install-recommends \
#&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
#&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
#&& apt-get update && apt-get install -y \
#google-chrome-stable \
#--no-install-recommends \
#&& dpkg -i '/src/google-talkplugin_current_amd64.deb' \
#&& apt-get purge --auto-remove -y curl \
#&& rm -rf /var/lib/apt/lists/* \
#&& rm -rf /src/*.deb
#
#cp /root/scripts/local.conf /etc/fonts/local.conf
#google-chrome "http://google.com"

elif [ $INSTALL == "java" ]; then
apt-get install software-properties-common -y
apt-get install -y default-jre
java -jar /root/java/*.jar
elif [ -z $INSTALL ]; then
echo "nothing to install"
fi


for i in "$@"
do
case $i in
    # if option `-t` or `--tail-log` block the execution and tail the VNC log
    -t|--tail-log)
    echo -e "\n------------------ /root/.vnc/*$DISPLAY.log ------------------"
    tail -f /root/.vnc/*$DISPLAY.log
    ;;
    *)
    # unknown option ==> call command
    exec $i
    ;;
esac
done
