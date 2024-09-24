#!/bin/bash  
Xvfb :1 -screen 0 1024x768x16 &  
vncserver :1 -geometry 1024x768 -depth 16 -passwordfile /root/.vnc/passwd &  
fluxbox & 
/opt/novnc/utils/websockify --web /opt/novnc --no-tls 6080 localhost:5901
im-config -n fcitx5  
fcitx5 &
/opt/tinyMediaManager/tinyMediaManager